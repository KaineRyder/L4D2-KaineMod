#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <dhooks>
#include <left4dhooks>
#include <l4d2lib>
#include <colors>

#define GAMEDATA_FILE "kaine_finite_hordes"

enum HordeSource
{
	HordeSource_None = 0,
	HordeSource_Crescendo,
	HordeSource_AlarmCar,
	HordeSource_Finale
}

DynamicDetour g_hPanicEventDetour;
HordeSource g_eHordeSource = HordeSource_None;
int g_iEventLimit = 150;
int g_iMapSpawned;
int g_iNextNotice;
int g_iEventSerial;
bool g_bEventAnnounced;
bool g_bLimitAnnounced;
bool g_bFinaleStarted;

public Plugin myinfo =
{
		name = "Kaine finite crescendo hordes",
	author = "KaineMod",
	description = "Applies a shared per-round common quota to scripted crescendos in Kaine modes",
	version = "1.0"
};

public void OnPluginStart()
{
	LoadTranslations("l4d2_horde_equaliser.phrases");

	GameData gd = new GameData(GAMEDATA_FILE);
	if (!gd)
	{
		SetFailState("Missing gamedata " ... GAMEDATA_FILE ... ".txt");
	}

	g_hPanicEventDetour = DynamicDetour.FromConf(gd, "CDirector::OnMapInvokedPanicEvent");
	delete gd;
	if (!g_hPanicEventDetour || !g_hPanicEventDetour.Enable(Hook_Post, Detour_OnMapInvokedPanicEvent_Post))
	{
		SetFailState("Failed to hook CDirector::OnMapInvokedPanicEvent");
	}

	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	HookEvent("finale_start", Event_FinaleStart, EventHookMode_PostNoCopy);
	HookEvent("finale_radio_start", Event_FinaleStart, EventHookMode_PostNoCopy);
	HookEvent("gauntlet_finale_start", Event_FinaleStart, EventHookMode_PostNoCopy);
}

public void OnMapStart()
{
	ResetEventState();
	g_bFinaleStarted = false;
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (strcmp(classname, "infected") != 0 || g_eHordeSource != HordeSource_Crescendo || !IsInfiniteHordeActive())
	{
		return;
	}

	if (g_iMapSpawned >= g_iEventLimit)
	{
		L4D2Direct_SetPendingMobCount(0);
		AnnounceExhaustion();
		return;
	}

	g_iMapSpawned++;
	int remaining = g_iEventLimit - g_iMapSpawned;
	while (g_iNextNotice > 0 && remaining <= g_iNextNotice)
	{
		CPrintToChatAll("%t %t", "Tag", "CommonRemaining", remaining);
		g_iNextNotice -= (g_iEventLimit + 3) / 4;
	}

	if (g_iMapSpawned >= g_iEventLimit)
	{
		L4D2Direct_SetPendingMobCount(0);
		AnnounceExhaustion();
	}
}

void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	ResetEventState();
	g_bFinaleStarted = false;
}

void Event_FinaleStart(Event event, const char[] name, bool dontBroadcast)
{
	g_bFinaleStarted = true;
	g_eHordeSource = HordeSource_Finale;
}

MRESReturn Detour_OnMapInvokedPanicEvent_Post(int director, Handle hReturn, Handle hParams)
{
	// Gamedata declares argument 2 as an int, not a pointer; DHookIsNullParam
	// is only valid for pointer arguments.
	int panicType = DHookGetParam(hParams, 2);
	LogMessage("[KaineFiniteHorde] panic detour: type=%d finale=%d", panicType, g_bFinaleStarted);
	if (panicType == 1)
	{
		// Alarm-car panic type. Do not inherit or consume a crescendo quota.
		g_eHordeSource = HordeSource_AlarmCar;
		return MRES_Ignored;
	}

	// The stock horde notifier treats every non-alarm panic type as a crescendo.
	// Custom maps may pass a panic reason other than the usual value 0.
	if (!g_bFinaleStarted)
	{
		StartCrescendoEvent();
	}

	return MRES_Ignored;
}

public Action L4D_OnSpawnMob(int &amount)
{
	bool hordeActive = IsInfiniteHordeActive();
	if (hordeActive && g_eHordeSource == HordeSource_None && !g_bFinaleStarted)
	{
		// Some map scripts start the director horde timer without calling the
		// panic-event detour. Detect that event at its first mob spawn instead.
		LogMessage("[KaineFiniteHorde] fallback detected active horde timer");
		StartCrescendoEvent();
	}

	if (!hordeActive)
	{
		if (g_eHordeSource != HordeSource_Finale)
		{
			g_eHordeSource = HordeSource_None;
		}
		return Plugin_Continue;
	}

	if (g_eHordeSource == HordeSource_AlarmCar || g_eHordeSource == HordeSource_Finale || g_bFinaleStarted)
	{
		return Plugin_Continue;
	}

	if (g_eHordeSource != HordeSource_Crescendo)
	{
		return Plugin_Continue;
	}

	if (!g_bEventAnnounced)
	{
		CPrintToChatAll("%t %t", "Tag", "FiniteEventStarted", g_iEventLimit);
		g_bEventAnnounced = true;
	}

	if (g_iMapSpawned >= g_iEventLimit)
	{
		L4D2Direct_SetPendingMobCount(0);
		amount = 0;
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

void StartCrescendoEvent()
{
	if (g_eHordeSource != HordeSource_Crescendo)
	{
		g_iEventSerial++;
		LogMessage("[KaineFiniteHorde] crescendo detected: serial=%d mapSpawned=%d limit=%d", g_iEventSerial, g_iMapSpawned, g_iEventLimit);
	}
	g_eHordeSource = HordeSource_Crescendo;
	if (!g_bEventAnnounced)
	{
		CPrintToChatAll("%t %t", "Tag", "FiniteEventStarted", g_iEventLimit);
		g_bEventAnnounced = true;
	}
}

void AnnounceExhaustion()
{
	if (!g_bLimitAnnounced)
	{
		LogMessage("[KaineFiniteHorde] map quota reached: spawned=%d limit=%d", g_iMapSpawned, g_iEventLimit);
		CPrintToChatAll("%t %t", "Tag", "NoCommonRemaining");
		g_bLimitAnnounced = true;
	}
}

void ResetEventState()
{
	g_eHordeSource = HordeSource_None;
	g_iEventLimit = L4D2_GetMapValueInt("horde_limit", 150);
	if (g_iEventLimit < 0)
	{
		g_iEventLimit = 150;
	}
	g_iMapSpawned = 0;
	g_iNextNotice = g_iEventLimit - (g_iEventLimit + 3) / 4;
	g_bEventAnnounced = false;
	g_bLimitAnnounced = false;
}

bool IsInfiniteHordeActive()
{
	CountdownTimer timer = L4D2Direct_GetMobSpawnTimer();
	if (!CTimer_HasStarted(timer))
	{
		return false;
	}

	int remaining = RoundFloat(CTimer_GetRemainingTime(timer));
	return remaining >= 0 && remaining <= 10;
}
