#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

#define INCAP_HEALTH_MAX 300.0
#define INCAP_HEALTH_THRESHOLD 285.0
#define REVIVE_TEMP_HEALTH_MIN 20.0
#define REVIVE_TEMP_HEALTH_MAX 45.0

bool g_bTrackingIncap[MAXPLAYERS + 1];
float g_fLastIncapHealth[MAXPLAYERS + 1];

public Plugin myinfo =
{
	name = "KaineMod Revive Temporary Health",
	author = "KaineMod",
	description = "Scales revived temporary health based on incapacitated health lost",
	version = "1.0"
};

public void OnPluginStart()
{
	HookEvent("player_incapacitated_start", Event_PlayerIncapacitated, EventHookMode_Post);
	HookEvent("revive_success", Event_ReviveSuccess, EventHookMode_Post);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
	HookEvent("player_bot_replace", Event_PlayerBotReplace, EventHookMode_Post);
	HookEvent("bot_player_replace", Event_PlayerBotReplace, EventHookMode_Post);
	HookEvent("round_start", Event_ResetTracking, EventHookMode_Post);
	HookEventEx("round_end", Event_ResetTracking, EventHookMode_Post);
	HookEventEx("mission_lost", Event_ResetTracking, EventHookMode_Post);

	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsValidSurvivor(client) && IsIncapacitated(client))
		{
			StartTrackingIncap(client);
		}
	}
}

public void OnMapStart()
{
	ResetAllTracking();
}

public void OnClientDisconnect(int client)
{
	ClearTracking(client);
}

public void OnGameFrame()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (!g_bTrackingIncap[client] || !IsValidSurvivor(client) || !IsIncapacitated(client))
		{
			continue;
		}

		g_fLastIncapHealth[client] = ReadIncapHealth(client);
	}
}

void Event_PlayerIncapacitated(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidSurvivor(client))
	{
		StartTrackingIncap(client);
	}
}

void Event_ReviveSuccess(Event event, const char[] name, bool dontBroadcast)
{
	if (event.GetBool("ledge_hang"))
	{
		return;
	}

	int client = GetClientOfUserId(event.GetInt("subject"));
	if (!IsValidSurvivor(client) || !g_bTrackingIncap[client])
	{
		return;
	}

	// The post event runs after the game has revived the survivor and cleared
	// the incap state, so use the most recent health sampled while incapacitated.
	float reviveHealth = CalculateReviveTempHealth(g_fLastIncapHealth[client]);
	SetReviveTempHealth(client, reviveHealth);
	ClearTracking(client);
}

void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	ClearTracking(client);
}

void Event_PlayerBotReplace(Event event, const char[] name, bool dontBroadcast)
{
	int bot = GetClientOfUserId(event.GetInt("bot"));
	int player = GetClientOfUserId(event.GetInt("player"));
	int source = StrEqual(name, "player_bot_replace") ? player : bot;
	int target = StrEqual(name, "player_bot_replace") ? bot : player;

	if (!IsValidClient(source) || !IsValidClient(target))
	{
		return;
	}

	g_bTrackingIncap[target] = g_bTrackingIncap[source];
	g_fLastIncapHealth[target] = g_fLastIncapHealth[source];
	ClearTracking(source);
}

void Event_ResetTracking(Event event, const char[] name, bool dontBroadcast)
{
	ResetAllTracking();
}

void StartTrackingIncap(int client)
{
	g_bTrackingIncap[client] = true;
	g_fLastIncapHealth[client] = ReadIncapHealth(client);
}

float ReadIncapHealth(int client)
{
	float health = float(GetEntProp(client, Prop_Send, "m_iHealth"));
	if (health < 0.0)
	{
		return 0.0;
	}
	if (health > INCAP_HEALTH_MAX)
	{
		return INCAP_HEALTH_MAX;
	}
	return health;
}

float CalculateReviveTempHealth(float remainingIncapHealth)
{
	if (remainingIncapHealth < 0.0)
	{
		remainingIncapHealth = 0.0;
	}
	else if (remainingIncapHealth > INCAP_HEALTH_MAX)
	{
		remainingIncapHealth = INCAP_HEALTH_MAX;
	}

	float result;
	if (remainingIncapHealth >= INCAP_HEALTH_THRESHOLD)
	{
		result = REVIVE_TEMP_HEALTH_MAX;
	}
	else
	{
		float fraction = remainingIncapHealth / INCAP_HEALTH_THRESHOLD;
		result = REVIVE_TEMP_HEALTH_MIN
			+ (REVIVE_TEMP_HEALTH_MAX - REVIVE_TEMP_HEALTH_MIN) * Pow(fraction, 2.5);
	}

	if (result < REVIVE_TEMP_HEALTH_MIN)
	{
		return REVIVE_TEMP_HEALTH_MIN;
	}
	if (result > REVIVE_TEMP_HEALTH_MAX)
	{
		return REVIVE_TEMP_HEALTH_MAX;
	}
	return result;
}

void SetReviveTempHealth(int client, float health)
{
	SetEntPropFloat(client, Prop_Send, "m_healthBuffer", health);
	SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
}

bool IsValidSurvivor(int client)
{
	return IsValidClient(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client);
}

bool IsValidClient(int client)
{
	return client >= 1 && client <= MaxClients && IsClientInGame(client);
}

bool IsIncapacitated(int client)
{
	return GetEntProp(client, Prop_Send, "m_isIncapacitated", 1) != 0;
}

void ClearTracking(int client)
{
	if (client < 1 || client > MaxClients)
	{
		return;
	}

	g_bTrackingIncap[client] = false;
	g_fLastIncapHealth[client] = 0.0;
}

void ResetAllTracking()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		ClearTracking(client);
	}
}
