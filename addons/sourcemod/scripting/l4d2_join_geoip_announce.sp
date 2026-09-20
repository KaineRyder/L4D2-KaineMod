#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <SteamWorks>

#define PLUGIN_VERSION "1.2.1"
#define IP_MAX_LENGTH 64
#define LOCATION_MAX_LENGTH 128
#define FALLBACK_LOCATION "苏联"

ConVar
	g_hEnabled,
	g_hDelay,
	g_hShowIP,
	g_hAPIURL,
	g_hTimeout;

StringMap g_hLocationCache;
bool g_bSteamWorksAvailable;
int g_iPendingUserID[MAXPLAYERS + 1];
char g_sPendingIP[MAXPLAYERS + 1][IP_MAX_LENGTH];

public Plugin myinfo =
{
	name = "[L4D2] Join GeoIP Announce",
	author = "OpenAI",
	description = "Queries the UAPI IP service and announces a player's province and city before the playtime message.",
	version = PLUGIN_VERSION
};

public void OnPluginStart()
{
	g_hEnabled = CreateConVar(
		"l4d2_join_geoip_enabled",
		"1",
		"Enable the join location announcement.",
		FCVAR_NOTIFY,
		true,
		0.0,
		true,
		1.0
	);

	g_hDelay = CreateConVar(
		"l4d2_join_geoip_delay",
		"1.0",
		"Seconds to wait after a player is fully connected before querying the location API.",
		FCVAR_NOTIFY,
		true,
		0.0,
		true,
		10.0
	);

	g_hShowIP = CreateConVar(
		"l4d2_join_geoip_show_ip",
		"1",
		"Show the connecting player's IP in chat.",
		FCVAR_NOTIFY,
		true,
		0.0,
		true,
		1.0
	);

	g_hAPIURL = CreateConVar(
		"l4d2_join_geoip_api",
		"https://uapis.cn/api/v1/network/ipinfo?ip=%s",
		"Location API URL. The URL must contain one %s placeholder for the player IP.",
		FCVAR_NOTIFY
	);

	g_hTimeout = CreateConVar(
		"l4d2_join_geoip_timeout",
		"5",
		"Location API request timeout in seconds.",
		FCVAR_NOTIFY,
		true,
		1.0,
		true,
		15.0
	);

	g_bSteamWorksAvailable = (GetExtensionFileStatus("SteamWorks.ext") == 1);
	if (!g_bSteamWorksAvailable)
	{
		LogError("SteamWorks is not installed or failed to load. Join location API queries are disabled.");
	}

	g_hLocationCache = new StringMap();
	AutoExecConfig(true, "l4d2_join_geoip_announce");
}

public void OnPluginEnd()
{
	delete g_hLocationCache;
}

public void OnMapStart()
{
	if (g_hLocationCache != null)
	{
		g_hLocationCache.Clear();
	}
}

public void OnClientDisconnect(int client)
{
	g_iPendingUserID[client] = 0;
	g_sPendingIP[client][0] = '\0';
}

public void OnClientPostAdminCheck(int client)
{
	if (!g_hEnabled.BoolValue || !IsValidHumanClient(client))
	{
		return;
	}

	CreateTimer(
		g_hDelay.FloatValue,
		Timer_QueryJoinLocation,
		GetClientUserId(client),
		TIMER_FLAG_NO_MAPCHANGE
	);
}

Action Timer_QueryJoinLocation(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (!g_hEnabled.BoolValue || !IsValidHumanClient(client))
	{
		return Plugin_Stop;
	}

	char ip[IP_MAX_LENGTH];
	if (!GetClientIP(client, ip, sizeof(ip), true) || ip[0] == '\0')
	{
		AnnounceJoin(client, FALLBACK_LOCATION, "未知");
		return Plugin_Stop;
	}

	char cachedLocation[LOCATION_MAX_LENGTH];
	if (g_hLocationCache.GetString(ip, cachedLocation, sizeof(cachedLocation)))
	{
		AnnounceJoin(client, cachedLocation, ip);
		return Plugin_Stop;
	}

	if (!g_bSteamWorksAvailable)
	{
		AnnounceJoin(client, FALLBACK_LOCATION, ip);
		return Plugin_Stop;
	}

	if (g_iPendingUserID[client] == userid)
	{
		return Plugin_Stop;
	}

	char apiTemplate[512];
	g_hAPIURL.GetString(apiTemplate, sizeof(apiTemplate));
	if (StrContains(apiTemplate, "%s", false) == -1)
	{
		LogError("l4d2_join_geoip_api must contain a %%s placeholder for the player IP.");
		AnnounceJoin(client, FALLBACK_LOCATION, ip);
		return Plugin_Stop;
	}

	char url[768];
	FormatEx(url, sizeof(url), apiTemplate, ip);

	Handle request = SteamWorks_CreateHTTPRequest(k_EHTTPMethodGET, url);
	if (request == null)
	{
		LogError("Failed to create join location API request for %s.", ip);
		AnnounceJoin(client, FALLBACK_LOCATION, ip);
		return Plugin_Stop;
	}

	g_iPendingUserID[client] = userid;
	strcopy(g_sPendingIP[client], sizeof(g_sPendingIP[]), ip);

	SteamWorks_SetHTTPRequestNetworkActivityTimeout(request, g_hTimeout.IntValue);
	SteamWorks_SetHTTPRequestContextValue(request, userid);
	SteamWorks_SetHTTPCallbacks(request, OnJoinLocationHTTPCompleted);

	if (!SteamWorks_SendHTTPRequest(request))
	{
		g_iPendingUserID[client] = 0;
		g_sPendingIP[client][0] = '\0';
		CloseHandle(request);
		AnnounceJoin(client, FALLBACK_LOCATION, ip);
	}

	return Plugin_Stop;
}

public void OnJoinLocationHTTPCompleted(
	Handle request,
	bool failure,
	bool requestSuccessful,
	EHTTPStatusCode statusCode,
	any data1
)
{
	int userid = data1;
	int client = GetClientOfUserId(userid);
	bool pending = client > 0 && g_iPendingUserID[client] == userid;

	char ip[IP_MAX_LENGTH];
	ip[0] = '\0';
	if (pending)
	{
		strcopy(ip, sizeof(ip), g_sPendingIP[client]);
		g_iPendingUserID[client] = 0;
		g_sPendingIP[client][0] = '\0';
	}

	char location[LOCATION_MAX_LENGTH];
	bool success = false;

	if (!failure && requestSuccessful && statusCode == k_EHTTPStatusCode200OK && pending && IsValidHumanClient(client))
	{
		int bodySize;
		if (SteamWorks_GetHTTPResponseBodySize(request, bodySize) && bodySize > 0)
		{
			char[] body = new char[bodySize + 1];
			body[bodySize] = '\0';

			if (SteamWorks_GetHTTPResponseBodyData(request, body, bodySize))
			{
				success = ParseLocationResponse(body, location, sizeof(location));
			}
		}
	}

	if (pending && IsValidHumanClient(client))
	{
		if (success)
		{
			g_hLocationCache.SetString(ip, location);
			AnnounceJoin(client, location, ip);
		}
		else
		{
			LogMessage("Join location API query failed for %s (http=%d failure=%d successful=%d).", ip, statusCode, failure, requestSuccessful);
			AnnounceJoin(client, FALLBACK_LOCATION, ip);
		}
	}

	CloseHandle(request);
}

bool ParseLocationResponse(const char[] body, char[] location, int maxlen)
{
	location[0] = '\0';

	char uapiRegion[128];
	if (ExtractJSONString(body, "region", uapiRegion, sizeof(uapiRegion))
		&& ParseUAPIRegion(uapiRegion, location, maxlen))
	{
		return true;
	}

	char status[16];
	if (!ExtractJSONString(body, "status", status, sizeof(status)) || !StrEqual(status, "success", false))
	{
		return false;
	}

	char region[64];
	char city[64];
	ExtractJSONString(body, "regionName", region, sizeof(region));
	ExtractJSONString(body, "city", city, sizeof(city));

	if (region[0] != '\0' && city[0] != '\0')
	{
		FormatEx(location, maxlen, "%s %s", region, city);
		return true;
	}

	if (region[0] != '\0')
	{
		strcopy(location, maxlen, region);
		return true;
	}

	if (city[0] != '\0')
	{
		strcopy(location, maxlen, city);
		return true;
	}

	return false;
}

bool ParseUAPIRegion(const char[] region, char[] location, int maxlen)
{
	char parts[5][64];
	int count = ExplodeString(region, " ", parts, sizeof(parts), sizeof(parts[]), false);

	if (count >= 3 && StrEqual(parts[0], "中国", false))
	{
		char province[64];
		char city[64];
		FormatChinaProvince(parts[1], province, sizeof(province));
		FormatChinaCity(parts[2], city, sizeof(city));
		FormatEx(location, maxlen, "%s %s", province, city);
		return true;
	}

	if (count >= 2)
	{
		FormatEx(location, maxlen, "%s %s", parts[count - 2], parts[count - 1]);
		return true;
	}

	strcopy(location, maxlen, region);
	return location[0] != '\0';
}

void FormatChinaProvince(const char[] source, char[] output, int maxlen)
{
	if (StrEqual(source, "北京") || StrEqual(source, "上海")
		|| StrEqual(source, "天津") || StrEqual(source, "重庆"))
	{
		FormatEx(output, maxlen, "%s市", source);
	}
	else if (StrEqual(source, "内蒙古") || StrEqual(source, "广西")
		|| StrEqual(source, "西藏") || StrEqual(source, "宁夏")
		|| StrEqual(source, "新疆"))
	{
		FormatEx(output, maxlen, "%s自治区", source);
	}
	else if (StrEqual(source, "香港") || StrEqual(source, "澳门"))
	{
		FormatEx(output, maxlen, "%s", source);
	}
	else
	{
		FormatEx(output, maxlen, "%s省", source);
	}
}

void FormatChinaCity(const char[] source, char[] output, int maxlen)
{
	if (StrContains(source, "市", false) != -1
		|| StrContains(source, "自治州", false) != -1
		|| StrContains(source, "地区", false) != -1
		|| StrEqual(source, "香港")
		|| StrEqual(source, "澳门"))
	{
		strcopy(output, maxlen, source);
	}
	else
	{
		FormatEx(output, maxlen, "%s市", source);
	}
}

bool ExtractJSONString(const char[] json, const char[] key, char[] value, int maxlen)
{
	value[0] = '\0';

	char needle[64];
	FormatEx(needle, sizeof(needle), "\"%s\"", key);

	int position = StrContains(json, needle, false);
	if (position == -1)
	{
		return false;
	}

	position += strlen(needle);
	while (json[position] != '\0' && json[position] != ':')
	{
		position++;
	}

	if (json[position] != ':')
	{
		return false;
	}

	position++;
	while (json[position] == ' ' || json[position] == '\t')
	{
		position++;
	}

	if (json[position] != '"')
	{
		return false;
	}

	position++;
	int length = 0;
	while (json[position] != '\0' && json[position] != '"' && length < maxlen - 1)
	{
		value[length++] = json[position++];
	}
	value[length] = '\0';

	return json[position] == '"';
}

void AnnounceJoin(int client, const char[] location, const char[] ip)
{
	if (!IsValidHumanClient(client))
	{
		return;
	}

	if (g_hShowIP.BoolValue)
	{
		PrintToChatAll(
			"\x04[玩家加入]\x01来自 \x05%s\x01（IP:\x05%s\x01）的玩家\x03%N\x01加入游戏",
			location,
			ip,
			client
		);
	}
	else
	{
		PrintToChatAll(
			"\x04[玩家加入]\x01来自 \x05%s\x01的玩家\x03%N\x01加入游戏",
			location,
			client
		);
	}
}

bool IsValidHumanClient(int client)
{
	return client > 0
		&& client <= MaxClients
		&& IsClientInGame(client)
		&& !IsFakeClient(client);
}
