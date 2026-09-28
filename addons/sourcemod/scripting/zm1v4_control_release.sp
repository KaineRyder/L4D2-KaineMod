#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <left4dhooks>

#define ZC_SMOKER 1
#define ZC_HUNTER 3
#define ZC_JOCKEY 5
#define ZC_CHARGER 6

bool g_bApplyingControlDamage[MAXPLAYERS + 1];

public Plugin myinfo =
{
	name = "ZoneMod 1v4 Control Release",
	author = "ZoneMod",
	description = "Ends 1v4 infected pins with one point of damage after the survivor is pinned",
	version = "1.1.0"
};

public void OnPluginStart()
{
	if (GetFeatureStatus(FeatureType_Native, "L4D_Smoker_ReleaseVictim") != FeatureStatus_Available)
		SetFailState("L4D_Smoker_ReleaseVictim native unavailable; Left4DHooks is required");

	HookEvent("lunge_pounce", Event_ControlStart);
	HookEvent("jockey_ride", Event_ControlStart);
	HookEvent("charger_carry_start", Event_ControlStart);
	HookEvent("charger_pummel_start", Event_ControlStart);

	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client))
			SDKHook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage);
	}
}

public void OnClientPutInServer(int client)
{
	g_bApplyingControlDamage[client] = false;
	SDKHook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage);
}

public void OnClientDisconnect(int client)
{
	g_bApplyingControlDamage[client] = false;
}

public void L4D_OnGrabWithTongue_Post(int victim, int attacker)
{
	if (!IsValidPair(victim, attacker) || GetEntProp(attacker, Prop_Send, "m_zombieClass") != ZC_SMOKER)
		return;

	// The tongue grab begins while the survivor can still move, fire, and shove.
	// Wait for the actual hanging/pinned state before ending this control.
	CreateTimer(0.05, Timer_WaitForSmokerPin, GetClientUserId(victim), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

Action Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damageType)
{
	if (g_bApplyingControlDamage[victim] || damage <= 0.0 || !IsClientInGame(victim) || GetClientTeam(victim) != 2)
		return Plugin_Continue;

	int owner = GetControlOwner(victim);
	if (owner > 0 && owner <= MaxClients && attacker == owner && IsClientInGame(owner)
		&& GetClientTeam(owner) == 3 && IsPlayerAlive(owner))
	{
		// Suppress all natural pin ticks. The controller below applies one manual point
		// once the victim is truly pinned, avoiding a race with the next damage tick.
		damage = 0.0;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

Action Timer_WaitForSmokerPin(Handle timer, any victimUserId)
{
	int victim = GetClientOfUserId(victimUserId);
	if (victim < 1 || victim > MaxClients || !IsClientInGame(victim) || !IsPlayerAlive(victim)
		|| GetClientTeam(victim) != 2)
	{
		return Plugin_Stop;
	}

	int attacker = GetEntPropEnt(victim, Prop_Send, "m_tongueOwner");
	if (attacker < 1 || attacker > MaxClients || !IsValidPair(victim, attacker)
		|| GetEntProp(attacker, Prop_Send, "m_zombieClass") != ZC_SMOKER)
	{
		return Plugin_Stop;
	}

	if (GetEntProp(victim, Prop_Send, "m_isHangingFromTongue", 1) <= 0)
		return Plugin_Continue;

	ApplyOneControlDamage(victim, attacker);
	L4D_Smoker_ReleaseVictim(victim, attacker);
	KillController(attacker);
	return Plugin_Stop;
}

void Event_ControlStart(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(event.GetInt("userid"));
	int victim = GetClientOfUserId(event.GetInt("victim"));
	if (!IsValidPair(victim, attacker))
		return;

	int zombieClass = GetEntProp(attacker, Prop_Send, "m_zombieClass");
	if (zombieClass != ZC_HUNTER && zombieClass != ZC_JOCKEY && zombieClass != ZC_CHARGER)
		return;

	DataPack data;
	CreateDataTimer(0.05, Timer_EnsureControlReleased, data, TIMER_FLAG_NO_MAPCHANGE);
	data.WriteCell(GetClientUserId(attacker));
	data.WriteCell(GetClientUserId(victim));
	data.WriteCell(zombieClass);
}

Action Timer_EnsureControlReleased(Handle timer, DataPack data)
{
	data.Reset();
	int attacker = GetClientOfUserId(data.ReadCell());
	int victim = GetClientOfUserId(data.ReadCell());
	int zombieClass = data.ReadCell();
	if (!IsValidPair(victim, attacker) || !IsPinnedBy(victim, attacker, zombieClass))
		return Plugin_Stop;

	ApplyOneControlDamage(victim, attacker);
	KillController(attacker);
	return Plugin_Stop;
}

void ApplyOneControlDamage(int victim, int attacker)
{
	g_bApplyingControlDamage[victim] = true;
	SDKHooks_TakeDamage(victim, attacker, attacker, 1.0, DMG_GENERIC);
	g_bApplyingControlDamage[victim] = false;
}

void KillController(int attacker)
{
	if (attacker > 0 && attacker <= MaxClients && IsClientInGame(attacker) && IsPlayerAlive(attacker))
		ForcePlayerSuicide(attacker);
}

int GetControlOwner(int victim)
{
	if (GetEntPropEnt(victim, Prop_Send, "m_tongueOwner") > 0)
		return GetEntPropEnt(victim, Prop_Send, "m_tongueOwner");
	if (GetEntPropEnt(victim, Prop_Send, "m_pounceAttacker") > 0)
		return GetEntPropEnt(victim, Prop_Send, "m_pounceAttacker");
	if (GetEntPropEnt(victim, Prop_Send, "m_jockeyAttacker") > 0)
		return GetEntPropEnt(victim, Prop_Send, "m_jockeyAttacker");
	if (GetEntPropEnt(victim, Prop_Send, "m_carryAttacker") > 0)
		return GetEntPropEnt(victim, Prop_Send, "m_carryAttacker");
	if (GetEntPropEnt(victim, Prop_Send, "m_pummelAttacker") > 0)
		return GetEntPropEnt(victim, Prop_Send, "m_pummelAttacker");
	return 0;
}

bool IsValidPair(int victim, int attacker)
{
	return victim > 0 && victim <= MaxClients && attacker > 0 && attacker <= MaxClients
		&& IsClientInGame(victim) && IsClientInGame(attacker)
		&& IsPlayerAlive(victim) && IsPlayerAlive(attacker)
		&& GetClientTeam(victim) == 2 && GetClientTeam(attacker) == 3;
}

bool IsPinnedBy(int victim, int attacker, int zombieClass)
{
	switch (zombieClass)
	{
		case ZC_HUNTER:
			return GetEntPropEnt(victim, Prop_Send, "m_pounceAttacker") == attacker;
		case ZC_JOCKEY:
			return GetEntPropEnt(victim, Prop_Send, "m_jockeyAttacker") == attacker;
		case ZC_CHARGER:
			return GetEntPropEnt(victim, Prop_Send, "m_carryAttacker") == attacker
				|| GetEntPropEnt(victim, Prop_Send, "m_pummelAttacker") == attacker;
	}
	return false;
}
