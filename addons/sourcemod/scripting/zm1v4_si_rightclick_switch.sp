#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <left4dhooks>

// Adapted from apples1949/applemod's l4d2_si_rightclick_switch.sp for ZoneMod 1v4.
// This plugin is loaded only by cfgogl/zm1v4/confogl_plugins.cfg.
#define ZC_SMOKER  1
#define ZC_HUNTER  3
#define ZC_JOCKEY  5
#define ZC_CHARGER 6

static const int g_iSwitchableClasses[] = {ZC_SMOKER, ZC_HUNTER, ZC_JOCKEY, ZC_CHARGER};
static const char g_sClassNames[][] =
{
	"Smoker", "Hunter", "Jockey", "Charger"
};

bool g_bAttack2[MAXPLAYERS + 1];
bool g_bHintShown[MAXPLAYERS + 1];

public Plugin myinfo =
{
	name = "ZoneMod 1v4 SI Right Click Switch",
	author = "apples1949, ZoneMod",
	description = "Right click to switch special infected class while in ghost state",
	version = "1.0.0",
	url = "https://github.com/apples1949/applemod"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	char game[12];
	GetGameFolderName(game, sizeof(game));
	if (!StrEqual(game, "left4dead2"))
	{
		strcopy(error, err_max, "This plugin only supports Left 4 Dead 2");
		return APLRes_Failure;
	}
	return APLRes_Success;
}

public void OnPluginStart()
{
	if (GetFeatureStatus(FeatureType_Native, "L4D_SetClass") != FeatureStatus_Available)
		SetFailState("L4D_SetClass native unavailable; Left4DHooks is required");

	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	HookEvent("player_team", Event_PlayerTeam);
	CreateTimer(0.5, Timer_ShowGhostHint, _, TIMER_REPEAT);
}

public void OnClientDisconnect(int client)
{
	g_bAttack2[client] = false;
	g_bHintShown[client] = false;
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	for (int client = 1; client <= MaxClients; client++)
	{
		g_bAttack2[client] = false;
		g_bHintShown[client] = false;
	}
}

public void Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client < 1 || client > MaxClients)
		return;

	g_bAttack2[client] = false;
	g_bHintShown[client] = false;
	if (event.GetInt("team") == 3)
		TryShowGhostHint(client);
}

public void L4D_OnEnterGhostState(int client)
{
	g_bAttack2[client] = false;
	g_bHintShown[client] = false;
	TryShowGhostHint(client);
}

public Action Timer_ShowGhostHint(Handle timer)
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsSwitchableGhost(client))
			TryShowGhostHint(client);
		else
			g_bHintShown[client] = false;
	}
	return Plugin_Continue;
}

void TryShowGhostHint(int client)
{
	if (!g_bHintShown[client] && IsSwitchableGhost(client))
	{
		PrintHintText(client, "按右键切换特感");
		g_bHintShown[client] = true;
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if (!IsSwitchableGhost(client))
	{
		g_bAttack2[client] = false;
		return Plugin_Continue;
	}

	if (!(buttons & IN_ATTACK2))
	{
		g_bAttack2[client] = false;
		return Plugin_Continue;
	}
	if (g_bAttack2[client])
		return Plugin_Continue;

	g_bAttack2[client] = true;
	int currentClass = GetEntProp(client, Prop_Send, "m_zombieClass");
	int classIndex = -1;
	for (int i = 0; i < sizeof(g_iSwitchableClasses); i++)
	{
		if (g_iSwitchableClasses[i] == currentClass)
		{
			classIndex = i;
			break;
		}
	}
	int nextIndex = classIndex == -1 ? 0 : (classIndex + 1) % sizeof(g_iSwitchableClasses);
	int nextClass = g_iSwitchableClasses[nextIndex];
	L4D_SetClass(client, nextClass);
	PrintHintText(client, "已切换到 %s（右键继续切换）", g_sClassNames[nextIndex]);
	g_bHintShown[client] = true;
	return Plugin_Continue;
}

bool IsSwitchableGhost(int client)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || IsFakeClient(client))
		return false;
	if (GetClientTeam(client) != 3 || !IsPlayerAlive(client))
		return false;
	if (!GetEntProp(client, Prop_Send, "m_isGhost"))
		return false;

	int zombieClass = GetEntProp(client, Prop_Send, "m_zombieClass");
	for (int i = 0; i < sizeof(g_iSwitchableClasses); i++)
	{
		if (g_iSwitchableClasses[i] == zombieClass)
			return true;
	}
	return false;
}
