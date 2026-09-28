#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

// Loaded only by the ZoneMod 1v4 match mode, before its confogl.cfg is run.
#define ZM1V4_INFECTED_LIMIT 29.0
#define ZM1V4_BASE_PLAYERS 4
#define ZM1V4_CLASS_COUNT 4

static const char g_sLimitCvars[ZM1V4_CLASS_COUNT + 1][] =
{
	"z_max_player_zombies",
	"z_versus_smoker_limit",
	"z_versus_hunter_limit",
	"z_versus_jockey_limit",
	"z_versus_charger_limit"
};
static const int g_iBaseClassLimits[ZM1V4_CLASS_COUNT] = {1, 2, 2, 2};

ConVar g_hLimits[ZM1V4_CLASS_COUNT + 1];
bool g_bHadUpperBound[ZM1V4_CLASS_COUNT + 1];
bool g_bChangedUpperBound[ZM1V4_CLASS_COUNT + 1];
float g_fOriginalUpperBound[ZM1V4_CLASS_COUNT + 1];

public Plugin myinfo =
{
	name = "ZoneMod 1v4 Infected Slots",
	author = "ZoneMod",
	description = "Allows the 1v4 mode to use its available server slots for infected players",
	version = "1.0.0"
};

public void OnPluginStart()
{
	for (int i = 0; i <= ZM1V4_CLASS_COUNT; i++)
	{
		g_hLimits[i] = FindConVar(g_sLimitCvars[i]);
		if (g_hLimits[i] == null)
			SetFailState("%s ConVar is unavailable", g_sLimitCvars[i]);

		g_bHadUpperBound[i] = g_hLimits[i].GetBounds(ConVarBound_Upper, g_fOriginalUpperBound[i]);
		if (!g_bHadUpperBound[i] || g_fOriginalUpperBound[i] < ZM1V4_INFECTED_LIMIT)
		{
			g_hLimits[i].SetBounds(ConVarBound_Upper, true, ZM1V4_INFECTED_LIMIT);
			g_bChangedUpperBound[i] = true;
		}
	}

	HookEvent("player_team", Event_PlayerTeam);
	CreateTimer(1.0, Timer_UpdateClassLimits, _, TIMER_REPEAT);
}

public void OnConfigsExecuted()
{
	UpdateClassLimits();
}

public void Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	CreateTimer(0.1, Timer_UpdateClassLimits, _, TIMER_FLAG_NO_MAPCHANGE);
}

public void OnClientDisconnect(int client)
{
	CreateTimer(0.1, Timer_UpdateClassLimits, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_UpdateClassLimits(Handle timer)
{
	UpdateClassLimits();
	return Plugin_Continue;
}

void UpdateClassLimits()
{
	int infectedPlayers = 0;
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 3)
			infectedPlayers++;
	}

	int extraPlayers = infectedPlayers - ZM1V4_BASE_PLAYERS;
	if (extraPlayers < 0)
		extraPlayers = 0;

	// Preserve the original 1v4 mix, then distribute extra slots across the
	// four naturally spawning classes. The three spare class slots let the next
	// player join before this callback raises the quotas again.
	for (int i = 0; i < ZM1V4_CLASS_COUNT; i++)
	{
		int extraForClass = extraPlayers / ZM1V4_CLASS_COUNT;
		if (i < extraPlayers % ZM1V4_CLASS_COUNT)
			extraForClass++;
		int wanted = g_iBaseClassLimits[i] + extraForClass;
		if (g_hLimits[i + 1].IntValue != wanted)
			g_hLimits[i + 1].SetInt(wanted);
	}
}

public void OnPluginEnd()
{
	for (int i = 0; i <= ZM1V4_CLASS_COUNT; i++)
	{
		if (g_bChangedUpperBound[i] && g_hLimits[i] != null)
			g_hLimits[i].SetBounds(ConVarBound_Upper, g_bHadUpperBound[i], g_fOriginalUpperBound[i]);
	}
}
