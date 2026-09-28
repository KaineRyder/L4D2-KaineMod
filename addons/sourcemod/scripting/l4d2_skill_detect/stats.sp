// Realtime details retained from l4d2_stats. The original skill detector remains
// responsible for its skeet classification and public forwards.

int SkillStats_g_iDamage[MAXPLAYERS + 1][MAXPLAYERS + 1];
int SkillStats_g_iShots[MAXPLAYERS + 1][MAXPLAYERS + 1];
int SkillStats_g_iLastHealth[MAXPLAYERS + 1];
bool SkillStats_g_bShotCounted[MAXPLAYERS + 1][MAXPLAYERS + 1];
bool SkillStats_g_bPouncing[MAXPLAYERS + 1];
bool SkillStats_g_bReported[MAXPLAYERS + 1];
bool SkillStats_g_bBoomed[MAXPLAYERS + 1];
float SkillStats_g_fBoomerSpawn[MAXPLAYERS + 1];

void SkillStats_OnPluginStart()
{
	HookEvent("weapon_fire", SkillStats_Event_WeaponFire, EventHookMode_Post);
	HookEvent("player_hurt", SkillStats_Event_PlayerHurt, EventHookMode_Pre);
	HookEvent("player_death", SkillStats_Event_PlayerDeath, EventHookMode_Post);
	HookEvent("player_spawn", SkillStats_Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("ability_use", SkillStats_Event_AbilityUse, EventHookMode_Post);
	HookEvent("lunge_pounce", SkillStats_Event_LungePounce, EventHookMode_Post);
	HookEvent("player_now_it", SkillStats_Event_PlayerBoomed, EventHookMode_Post);
	HookEvent("round_start", SkillStats_Event_RoundStart, EventHookMode_PostNoCopy);
}

void SkillStats_OnClientDisconnect(int client)
{
	SkillStats_ClearDamage(client);
	SkillStats_g_bPouncing[client] = false;
	SkillStats_g_bReported[client] = false;
	SkillStats_g_bBoomed[client] = false;
	SkillStats_g_fBoomerSpawn[client] = 0.0;
}

void SkillStats_OnMapStart()
{
	for (int i = 1; i <= MaxClients; i++)
		SkillStats_OnClientDisconnect(i);
}

void SkillStats_Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		SkillStats_ClearDamage(i);
		SkillStats_g_bPouncing[i] = false;
		SkillStats_g_bReported[i] = false;
		SkillStats_g_bBoomed[i] = false;
		SkillStats_g_fBoomerSpawn[i] = 0.0;
	}
}

void SkillStats_ClearDamage(int victim)
{
	SkillStats_g_iLastHealth[victim] = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		SkillStats_g_iDamage[victim][i] = 0;
		SkillStats_g_iShots[victim][i] = 0;
		SkillStats_g_bShotCounted[victim][i] = false;
	}
}

void SkillStats_Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!IS_VALID_INGAME(client)) return;

	SkillStats_ClearDamage(client);
	SkillStats_g_bPouncing[client] = false;
	SkillStats_g_bReported[client] = false;
	SkillStats_g_bBoomed[client] = false;
	SkillStats_g_fBoomerSpawn[client] = 0.0;
	if (IS_INFECTED(client))
	{
		int zombieClass = GetEntProp(client, Prop_Send, "m_zombieClass");
		if (zombieClass != ZC_TANK)
			SkillStats_g_iLastHealth[client] = GetClientHealth(client);
		if (zombieClass == ZC_BOOMER)
			SkillStats_g_fBoomerSpawn[client] = GetEngineTime();
	}
}

void SkillStats_Event_WeaponFire(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(event.GetInt("userid"));
	if (!IS_VALID_CLIENT(attacker)) return;
	for (int victim = 1; victim <= MaxClients; victim++)
		SkillStats_g_bShotCounted[victim][attacker] = false;
}

void SkillStats_Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if (!IS_VALID_INFECTED(victim) || !IS_VALID_SURVIVOR(attacker) ||
		GetEntProp(victim, Prop_Send, "m_zombieClass") == ZC_TANK) return;

	if (!SkillStats_g_bShotCounted[victim][attacker])
	{
		SkillStats_g_iShots[victim][attacker]++;
		SkillStats_g_bShotCounted[victim][attacker] = true;
	}

	int health = event.GetInt("health");
	if (health > 0)
	{
		SkillStats_g_iDamage[victim][attacker] += event.GetInt("dmg_health");
		SkillStats_g_iLastHealth[victim] = health;
	}
}

void SkillStats_Event_AbilityUse(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!IS_VALID_INFECTED(client) || GetEntProp(client, Prop_Send, "m_zombieClass") != ZC_HUNTER)
		return;
	SkillStats_g_bPouncing[client] = true;
	CreateTimer(0.5, SkillStats_Timer_GroundedCheck, event.GetInt("userid"),
		TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

void SkillStats_Event_LungePounce(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IS_VALID_CLIENT(client)) SkillStats_g_bPouncing[client] = false;
}

Action SkillStats_Timer_GroundedCheck(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (!IS_VALID_INGAME(client) || !SkillStats_g_bPouncing[client]) return Plugin_Stop;
	if (!(GetEntityFlags(client) & FL_ONGROUND)) return Plugin_Continue;
	SkillStats_g_bPouncing[client] = false;
	return Plugin_Stop;
}

void SkillStats_Event_PlayerBoomed(Event event, const char[] name, bool dontBroadcast)
{
	int boomer = GetClientOfUserId(event.GetInt("attacker"));
	if (IS_VALID_CLIENT(boomer)) SkillStats_g_bBoomed[boomer] = true;
}

int SkillStats_GetShots(int victim, int attacker, int fallback)
{
	if (IS_VALID_CLIENT(victim) && IS_VALID_CLIENT(attacker) &&
		SkillStats_g_iShots[victim][attacker] > 0)
		return SkillStats_g_iShots[victim][attacker];
	return fallback;
}

bool SkillStats_IsScoutHeadshot(int attacker, bool headshot)
{
	if (!headshot || !IS_VALID_SURVIVOR(attacker)) return false;
	char weapon[64];
	GetClientWeapon(attacker, weapon, sizeof(weapon));
	return StrEqual(weapon, "weapon_sniper_scout");
}

int SkillStats_SortAssisters(int[] x, int[] y, const int[][] array, Handle data)
{
	return y[1] - x[1];
}

bool SkillStats_ReportTeamSkeet(int attacker, int victim)
{
	if (!IS_VALID_SURVIVOR(attacker) || !IS_VALID_INGAME(victim)) return false;
	int[][] assisters = new int[MaxClients][2];
	int count = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (i == attacker || !IS_VALID_SURVIVOR(i) || SkillStats_g_iDamage[victim][i] <= 0)
			continue;
		assisters[count][0] = i;
		assisters[count][1] = SkillStats_g_iDamage[victim][i];
		count++;
	}
	if (!count) return false;
	SortCustom2D(assisters, count, SkillStats_SortAssisters);

	CPrintToChatAll("%t", "SkillStats_TeamSkeet", attacker, victim,
		SkillStats_g_iDamage[victim][attacker] + SkillStats_g_iLastHealth[victim],
		SkillStats_GetShots(victim, attacker, 1));

	for (int i = 0; i < count; i++)
	{
		int client = assisters[i][0];
		char assisterName[MAX_NAME_LENGTH];
		GetClientName(client, assisterName, sizeof(assisterName));
		CPrintToChatAll("{lightgreen}助攻：{olive}%s{default} ({green}%d{default} 伤害/{green}%d{default} 枪)",
			assisterName, assisters[i][1], SkillStats_g_iShots[victim][client]);
	}
	return true;
}

void SkillStats_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if (!IS_VALID_INFECTED(victim)) return;

	int zombieClass = GetEntProp(victim, Prop_Send, "m_zombieClass");
	if (IS_VALID_SURVIVOR(attacker) && zombieClass != ZC_TANK)
		SkillStats_g_iDamage[victim][attacker] += SkillStats_g_iLastHealth[victim];

	if (zombieClass == ZC_HUNTER && SkillStats_g_bPouncing[victim] &&
		!SkillStats_g_bReported[victim] && IS_VALID_SURVIVOR(attacker) &&
		g_bCvarReportEnable && (g_iCvarReportFlags & REP_SKEET))
	{
		if (SkillStats_IsScoutHeadshot(attacker, event.GetBool("headshot")))
			CPrintToChatAll("%t", "SkillStats_ScoutHeadshot", attacker, victim);
		else
		{
			int count = 0;
			for (int i = 1; i <= MaxClients; i++)
				if (i != attacker && IS_VALID_SURVIVOR(i) && SkillStats_g_iDamage[victim][i] > 0)
					count++;
			if (!count || !SkillStats_ReportTeamSkeet(attacker, victim))
				CPrintToChatAll("%t", "SkillStats_AirKill", attacker, victim,
					SkillStats_GetShots(victim, attacker, 1));
		}
	}
	else if (zombieClass == ZC_BOOMER && IS_VALID_SURVIVOR(attacker) &&
		!SkillStats_g_bBoomed[victim] && SkillStats_g_fBoomerSpawn[victim] > 0.0 &&
		g_bCvarReportEnable && (g_iCvarReportFlags & REP_POP))
	{
		float elapsed = GetEngineTime() - SkillStats_g_fBoomerSpawn[victim];
		if (elapsed <= 2.0)
		{
			DataPack pack = new DataPack();
			pack.WriteCell(GetClientUserId(attacker));
			pack.WriteCell(GetClientUserId(victim));
			pack.WriteFloat(elapsed);
			CreateTimer(0.2, SkillStats_Timer_BoomerKill, pack, TIMER_DATA_HNDL_CLOSE | TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	SkillStats_ClearDamage(victim);
	SkillStats_g_bPouncing[victim] = false;
	SkillStats_g_bReported[victim] = false;
}

Action SkillStats_Timer_BoomerKill(Handle timer, DataPack pack)
{
	pack.Reset();
	int attacker = GetClientOfUserId(pack.ReadCell());
	int boomer = GetClientOfUserId(pack.ReadCell());
	float elapsed = pack.ReadFloat();
	if (!IS_VALID_SURVIVOR(attacker) || !IS_VALID_CLIENT(boomer) ||
		SkillStats_g_bBoomed[boomer]) return Plugin_Stop;
	char stars[16] = "★";
	if (elapsed <= 0.5) strcopy(stars, sizeof(stars), "★★★");
	else if (elapsed <= 1.4) strcopy(stars, sizeof(stars), "★★");
	CPrintToChatAll("%t", "SkillStats_BoomerQuickKill", stars, attacker, elapsed);
	return Plugin_Stop;
}
