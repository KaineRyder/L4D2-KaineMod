// Advanced announcements included by the original plugin.


#define SkillAdvanced_MAX_EDICTS 2048

#define SkillAdvanced_TEAM_SURVIVOR 2
#define SkillAdvanced_TEAM_INFECTED 3

#define SkillAdvanced_ZC_BOOMER 2
#define SkillAdvanced_ZC_CHARGER 6
#define SkillAdvanced_ZC_TANK 8

#define SkillAdvanced_CONTROL_SCAN_INTERVAL 0.10
#define SkillAdvanced_HITTABLE_OWNER_TIME 1.00
#define SkillAdvanced_DAMAGE_DEDUPE_TIME 0.20
#define SkillAdvanced_HITTABLE_DEDUPE_TIME 0.60
#define SkillAdvanced_CHARGER_TEAMKILL_SHOT_TIME 0.10
#define SkillAdvanced_CHARGER_TEAMKILL_MAX_CHARGE_TIME 12.0
#define SkillAdvanced_CHARGER_TEAMKILL_EVENT_DEDUPE 0.25

#define SkillAdvanced_MULTI_CONTROL_MIN 2
#define SkillAdvanced_MULTI_CONTROL_MAX 4

ConVar SkillAdvanced_g_hCvarEnable;
ConVar SkillAdvanced_g_hCvarMultiControl;
ConVar SkillAdvanced_g_hCvarRoundEnd;
ConVar SkillAdvanced_g_hCvarCharger;
ConVar SkillAdvanced_g_hCvarChargerTeamKill;
ConVar SkillAdvanced_g_hCvarBoomer;
ConVar SkillAdvanced_g_hCvarTankRock;
ConVar SkillAdvanced_g_hCvarTankHittable;
ConVar SkillAdvanced_g_hCvarTankPunch;
ConVar SkillAdvanced_g_hCvarChargerWindow;
ConVar SkillAdvanced_g_hCvarBoomerWindow;
ConVar SkillAdvanced_g_hCvarTankPunchWindow;

Handle SkillAdvanced_g_hControlTimer;
Handle SkillAdvanced_g_hChargerReset[MAXPLAYERS + 1];
Handle SkillAdvanced_g_hBoomerReset[MAXPLAYERS + 1];
Handle SkillAdvanced_g_hTankPunchReset[MAXPLAYERS + 1];

// 多特感控制状态：一次控制表示一个特感正在控制一名幸存者。
int SkillAdvanced_g_iControlCount;
int SkillAdvanced_g_iControlAnnounced;
bool SkillAdvanced_g_bControlRoundEndAnnounced;
bool SkillAdvanced_g_bRoundEnded;

// 冲锋者撞击状态：同一次冲锋检测窗口内，每名受害者只记录一次。
bool SkillAdvanced_g_bChargerVictim[MAXPLAYERS + 1][MAXPLAYERS + 1];
int SkillAdvanced_g_iChargerVictimCount[MAXPLAYERS + 1];
int SkillAdvanced_g_iChargerAnnounced[MAXPLAYERS + 1];
float SkillAdvanced_g_fChargerLastHit[MAXPLAYERS + 1];

// 冲锋期间冲锋者被枪械击杀时的枪械伤害状态。
int SkillAdvanced_g_iChargerGunDamage[MAXPLAYERS + 1][MAXPLAYERS + 1];
int SkillAdvanced_g_iChargerGunShots[MAXPLAYERS + 1][MAXPLAYERS + 1];
float SkillAdvanced_g_fChargerGunLastShot[MAXPLAYERS + 1][MAXPLAYERS + 1];
bool SkillAdvanced_g_bChargerGunLastShotgun[MAXPLAYERS + 1][MAXPLAYERS + 1];
bool SkillAdvanced_g_bChargerGunTracking[MAXPLAYERS + 1];
bool SkillAdvanced_g_bChargerCarrying[MAXPLAYERS + 1];
bool SkillAdvanced_g_bChargerGunLethal[MAXPLAYERS + 1];
bool SkillAdvanced_g_bChargerGunLethalDuringCharge[MAXPLAYERS + 1];
int SkillAdvanced_g_iChargerGunLethalAttacker[MAXPLAYERS + 1];
int SkillAdvanced_g_iChargerLastGunAttacker[MAXPLAYERS + 1];
float SkillAdvanced_g_fChargerLastChargingGun[MAXPLAYERS + 1];
bool SkillAdvanced_g_bChargerChargeActive[MAXPLAYERS + 1];
bool SkillAdvanced_g_bChargerChargeHitTarget[MAXPLAYERS + 1];
float SkillAdvanced_g_fChargerChargeStart[MAXPLAYERS + 1];

// Boomer 喷吐状态：同一次喷吐检测窗口内，每名受害者只记录一次。
bool SkillAdvanced_g_bBoomerVictim[MAXPLAYERS + 1][MAXPLAYERS + 1];
int SkillAdvanced_g_iBoomerVictimCount[MAXPLAYERS + 1];
int SkillAdvanced_g_iBoomerAnnounced[MAXPLAYERS + 1];
float SkillAdvanced_g_fBoomerLastHit[MAXPLAYERS + 1];

// Tank 拳击状态：同一次拳击检测窗口内，每名受害者只记录一次。
bool SkillAdvanced_g_bTankPunchVictim[MAXPLAYERS + 1][MAXPLAYERS + 1];
int SkillAdvanced_g_iTankPunchVictimCount[MAXPLAYERS + 1];
int SkillAdvanced_g_iTankPunchAnnounced[MAXPLAYERS + 1];
float SkillAdvanced_g_fTankPunchLastHit[MAXPLAYERS + 1];

// 打铁伤害会保留到 player_incapacitated_start 事件，用于确认是否真的倒地。
int SkillAdvanced_g_iRecentHittableTank[MAXPLAYERS + 1];
float SkillAdvanced_g_fRecentHittableTime[MAXPLAYERS + 1];

// 石头命中和打铁倒地播报使用短暂的去重窗口，避免同一事件重复播报。
int SkillAdvanced_g_iLastRockTank[MAXPLAYERS + 1];
float SkillAdvanced_g_fLastRockAnnounce[MAXPLAYERS + 1];
int SkillAdvanced_g_iLastHittableTank[MAXPLAYERS + 1];
float SkillAdvanced_g_fLastHittableAnnounce[MAXPLAYERS + 1];

// 记录物理物体的实体输出，用于追踪 Tank 击中的物理物体。
bool SkillAdvanced_g_bHittableHooked[SkillAdvanced_MAX_EDICTS];
int SkillAdvanced_g_iLastHittableTankByEntity[SkillAdvanced_MAX_EDICTS];
float SkillAdvanced_g_fLastHittableEntityHit[SkillAdvanced_MAX_EDICTS];
int SkillAdvanced_g_iLastHittableOwnerTank;
float SkillAdvanced_g_fLastHittableOwnerHit;

public void SkillAdvanced_OnPluginStart()
{

	SkillAdvanced_g_hCvarEnable = CreateConVar(
		"l4d2_skill_advanced_enable", "1",
		"启用特感高光动作播报。",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarMultiControl = CreateConVar(
		"l4d2_skill_advanced_multi_control", "1",
		"播报特感队伍达到 2/3/4 控的里程碑。",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarRoundEnd = CreateConVar(
		"l4d2_skill_advanced_round_end", "1",
		"Enable round-end announcement when control count reaches alive survivor count.",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarCharger = CreateConVar(
		"l4d2_skill_advanced_charger", "1",
		"播报一次冲锋撞到 2/3/4 名不同幸存者。",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarChargerTeamKill = CreateConVar(
		"l4d2_skill_advanced_charger_teamkill", "1",
		"播报枪械击杀冲锋中的冲锋者；集火击杀时显示协助者和伤害。",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarBoomer = CreateConVar(
		"l4d2_skill_advanced_boomer", "1",
		"播报一次喷吐命中 2/3/4 名不同幸存者。",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarTankRock = CreateConVar(
		"l4d2_skill_advanced_tank_rock", "1",
		"播报 Tank 石头命中幸存者。",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarTankHittable = CreateConVar(
		"l4d2_skill_advanced_tank_hittable", "1",
		"播报 Tank 使用打铁物体将幸存者打倒。",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarTankPunch = CreateConVar(
		"l4d2_skill_advanced_tank_punch", "1",
		"播报 Tank 一拳同时命中 2/3/4 名不同幸存者。",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);
	SkillAdvanced_g_hCvarChargerWindow = CreateConVar(
		"l4d2_skill_advanced_charger_window", "0.75",
		"最后一次冲锋撞击后，多少秒后重置多目标计数。",
		FCVAR_NOTIFY, true, 0.10, true, 3.0);
	SkillAdvanced_g_hCvarBoomerWindow = CreateConVar(
		"l4d2_skill_advanced_boomer_window", "2.75",
		"最后一次喷吐命中后，多少秒后重置喷吐计数。",
		FCVAR_NOTIFY, true, 0.50, true, 6.0);
	SkillAdvanced_g_hCvarTankPunchWindow = CreateConVar(
		"l4d2_skill_advanced_tank_punch_window", "0.45",
		"最后一次 Tank 拳击命中后，多少秒后重置多目标计数。",
		FCVAR_NOTIFY, true, 0.10, true, 1.5);
	AutoExecConfig(true, "l4d2_skill_detect_advanced");

	HookEvent("round_start", SkillAdvanced_Event_RoundStart, EventHookMode_PostNoCopy);
	HookEventEx("scavenge_round_start", SkillAdvanced_Event_RoundStart, EventHookMode_PostNoCopy);
	HookEvent("round_end", SkillAdvanced_Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("map_transition", SkillAdvanced_Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("mission_lost", SkillAdvanced_Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("finale_win", SkillAdvanced_Event_RoundEnd, EventHookMode_PostNoCopy);

	HookEvent("ability_use", SkillAdvanced_Event_AbilityUse, EventHookMode_Post);
	HookEventEx("charger_charge_start", SkillAdvanced_Event_ChargerChargeStart, EventHookMode_Post);
	HookEventEx("charger_charge_end", SkillAdvanced_Event_ChargerChargeEnd, EventHookMode_Post);
	HookEvent("charger_impact", SkillAdvanced_Event_ChargerImpact, EventHookMode_Post);
	HookEventEx("charger_carry_start", SkillAdvanced_Event_ChargerCarryStart, EventHookMode_Post);
	HookEventEx("charger_carry_end", SkillAdvanced_Event_ChargerCarryEnd, EventHookMode_Post);
	HookEvent("player_now_it", SkillAdvanced_Event_PlayerNowIt, EventHookMode_Post);
	HookEvent("player_hurt", SkillAdvanced_Event_PlayerHurt, EventHookMode_Post);
	HookEvent("player_incapacitated_start", SkillAdvanced_Event_PlayerIncapStart, EventHookMode_Post);
	HookEventEx("player_incapacitated", SkillAdvanced_Event_PlayerIncapStart, EventHookMode_Post);
	HookEvent("player_death", SkillAdvanced_Event_PlayerDeath, EventHookMode_Post);
	HookEvent("player_team", SkillAdvanced_Event_PlayerTeam, EventHookMode_Post);

	SkillAdvanced_g_bRoundEnded = false;
	SkillAdvanced_StartControlTimer();

	CreateTimer(0.20, SkillAdvanced_Timer_HookExistingHittables, _, TIMER_FLAG_NO_MAPCHANGE);
}

public void SkillAdvanced_OnPluginEnd()
{
    delete SkillAdvanced_g_hControlTimer;
	SkillAdvanced_g_hControlTimer = null;

	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			SDKUnhook(client, SDKHook_OnTakeDamage, SkillAdvanced_OnTakeDamagePre);
			SDKUnhook(client, SDKHook_OnTakeDamagePost, SkillAdvanced_OnTakeDamagePost);
		}

		delete SkillAdvanced_g_hChargerReset[client];
		delete SkillAdvanced_g_hBoomerReset[client];
		delete SkillAdvanced_g_hTankPunchReset[client];
	}
}

public void SkillAdvanced_OnMapStart()
{
	for (int entity = 0; entity < SkillAdvanced_MAX_EDICTS; entity++)
	{
		SkillAdvanced_g_bHittableHooked[entity] = false;
	}
	SkillAdvanced_ResetHittableOwnerCache();

	SkillAdvanced_g_bRoundEnded = false;
	SkillAdvanced_ResetAllState();
	SkillAdvanced_StartControlTimer();
	CreateTimer(0.20, SkillAdvanced_Timer_HookExistingHittables, _, TIMER_FLAG_NO_MAPCHANGE);
}

public void SkillAdvanced_OnMapEnd()
{
    SkillAdvanced_g_bRoundEnded = true;
    delete SkillAdvanced_g_hControlTimer;
	SkillAdvanced_g_hControlTimer = null;
	SkillAdvanced_ResetAllState();
}

public void SkillAdvanced_OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, SkillAdvanced_OnTakeDamagePre);
	SDKHook(client, SDKHook_OnTakeDamagePost, SkillAdvanced_OnTakeDamagePost);
}

public void SkillAdvanced_OnClientDisconnect(int client)
{
	SDKUnhook(client, SDKHook_OnTakeDamage, SkillAdvanced_OnTakeDamagePre);
	SDKUnhook(client, SDKHook_OnTakeDamagePost, SkillAdvanced_OnTakeDamagePost);
	SkillAdvanced_ResetClientState(client);
}

public void SkillAdvanced_OnEntityCreated(int entity, const char[] classname)
{
	if (entity <= MaxClients || entity >= SkillAdvanced_MAX_EDICTS)
	{
		return;
	}

	if (SkillAdvanced_IsHittableClass(classname))
	{
		SDKHook(entity, SDKHook_SpawnPost, SkillAdvanced_OnHittableSpawned);
	}
}

public void SkillAdvanced_OnEntityDestroyed(int entity)
{
	if (entity < 0 || entity >= SkillAdvanced_MAX_EDICTS)
	{
		return;
	}

	SkillAdvanced_g_bHittableHooked[entity] = false;
	SkillAdvanced_g_iLastHittableTankByEntity[entity] = 0;
	SkillAdvanced_g_fLastHittableEntityHit[entity] = 0.0;
}

public void SkillAdvanced_Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
    SkillAdvanced_g_bRoundEnded = false;
	SkillAdvanced_ResetAllState();
	SkillAdvanced_ResetHittableOwnerCache();
	CreateTimer(0.20, SkillAdvanced_Timer_HookExistingHittables, _, TIMER_FLAG_NO_MAPCHANGE);
}

public void SkillAdvanced_Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
    SkillAdvanced_g_bRoundEnded = true;
	SkillAdvanced_ResetAllState();
	SkillAdvanced_ResetHittableOwnerCache();
}

public void SkillAdvanced_Event_AbilityUse(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!SkillAdvanced_IsValidInfected(client))
	{
		return;
	}

	char ability[64];
	event.GetString("ability", ability, sizeof(ability));

	if (StrEqual(ability, "ability_charge", false) && SkillAdvanced_GetZombieClass(client) == SkillAdvanced_ZC_CHARGER)
	{
		SkillAdvanced_ResetChargerState(client);
		SkillAdvanced_ResetChargerGunState(client);
		SkillAdvanced_BeginChargerCharge(client);
	}
	else if (StrEqual(ability, "ability_vomit", false) && SkillAdvanced_GetZombieClass(client) == SkillAdvanced_ZC_BOOMER)
	{
		SkillAdvanced_ResetBoomerState(client);
	}
}

public void SkillAdvanced_Event_ChargerChargeStart(Event event, const char[] name, bool dontBroadcast)
{
	int charger = GetClientOfUserId(event.GetInt("userid"));
	if (SkillAdvanced_IsValidInfected(charger) && SkillAdvanced_GetZombieClass(charger) == SkillAdvanced_ZC_CHARGER)
	{
		float now = GetGameTime();
		if (!SkillAdvanced_g_bChargerChargeActive[charger] ||
			SkillAdvanced_g_fChargerChargeStart[charger] <= 0.0 ||
			now - SkillAdvanced_g_fChargerChargeStart[charger] > SkillAdvanced_CHARGER_TEAMKILL_EVENT_DEDUPE)
		{
			SkillAdvanced_ResetChargerState(charger);
			SkillAdvanced_ResetChargerGunState(charger);
		}
		SkillAdvanced_BeginChargerCharge(charger);
	}
}

public void SkillAdvanced_Event_ChargerChargeEnd(Event event, const char[] name, bool dontBroadcast)
{
	int charger = GetClientOfUserId(event.GetInt("userid"));
	SkillAdvanced_EndChargerCharge(charger);
}

public void SkillAdvanced_Event_ChargerImpact(Event event, const char[] name, bool dontBroadcast)
{
	int charger = GetClientOfUserId(event.GetInt("userid"));
	int victim = GetClientOfUserId(event.GetInt("victim"));
	SkillAdvanced_RegisterChargerVictim(charger, victim);
	SkillAdvanced_EndChargerCharge(charger, true);
}

public void SkillAdvanced_Event_ChargerCarryStart(Event event, const char[] name, bool dontBroadcast)
{
	int charger = GetClientOfUserId(event.GetInt("userid"));
	int victim = GetClientOfUserId(event.GetInt("victim"));
	SkillAdvanced_RegisterChargerVictim(charger, victim);
	if (charger > 0 && charger <= MaxClients)
	{
		SkillAdvanced_g_bChargerCarrying[charger] = true;
		SkillAdvanced_EndChargerCharge(charger, true);
	}
}

public void SkillAdvanced_Event_ChargerCarryEnd(Event event, const char[] name, bool dontBroadcast)
{
	int charger = GetClientOfUserId(event.GetInt("userid"));
	if (charger > 0 && charger <= MaxClients)
	{
		SkillAdvanced_g_bChargerCarrying[charger] = false;
		SkillAdvanced_g_bChargerChargeHitTarget[charger] = true;
	}
}

public void SkillAdvanced_Event_PlayerNowIt(Event event, const char[] name, bool dontBroadcast)
{
	if (!event.GetBool("by_boomer") || event.GetBool("exploded"))
	{
		return;
	}

	int boomer = GetClientOfUserId(event.GetInt("attacker"));
	int victim = GetClientOfUserId(event.GetInt("userid"));
	SkillAdvanced_RegisterBoomerVictim(boomer, victim);
}

public void SkillAdvanced_Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	if (SkillAdvanced_IsValidInfected(victim) && SkillAdvanced_GetZombieClass(victim) == SkillAdvanced_ZC_CHARGER)
	{
		SkillAdvanced_TrackChargerGunDamage(event, victim);
		return;
	}

	if (!SkillAdvanced_IsValidSurvivor(victim))
	{
		return;
	}

	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	int attackerEntity = event.GetInt("attackerentid", -1);
	char weapon[64];
	event.GetString("weapon", weapon, sizeof(weapon));
	bool tankHittableFallback = SkillAdvanced_IsTankHittableFallback(attacker, weapon);
	bool missingSource = attacker <= 0 && attackerEntity <= 0 && weapon[0] == '\0';
	bool explicitHittable = SkillAdvanced_IsHittableEntity(attacker) ||
		SkillAdvanced_IsRecentHittableEntity(attacker) ||
		SkillAdvanced_IsHittableEntity(attackerEntity) ||
		SkillAdvanced_IsRecentHittableEntity(attackerEntity);
	int tank = SkillAdvanced_ResolveTank(attacker, attackerEntity);
	if (!SkillAdvanced_IsValidTank(tank) && explicitHittable)
	{
		tank = SkillAdvanced_GetLatestHittableTank();
	}
	if (!SkillAdvanced_IsValidTank(tank) && tankHittableFallback)
	{
		// l4d2_hittable_control 可能会把物理物体造成的伤害改写为 Tank 作为攻击者，
		// 同时清空 inflictor/attackerentid 字段。
		tank = attacker;
	}
	bool implicitHittable = false;
	if (!SkillAdvanced_IsValidTank(tank) && missingSource)
	{
		// 某些 L4D2 版本对物理物体造成的伤害不会填写 attacker/attackerentid/weapon。
		// 这种情况下，OnHitByTank 时间戳是可靠的判定依据。
		tank = SkillAdvanced_GetLatestHittableTank();
		implicitHittable = SkillAdvanced_IsValidTank(tank);
	}
	if (!SkillAdvanced_IsValidTank(tank))
	{
		tank = SkillAdvanced_GetRecentHittableTank(victim);
	}
	if (!SkillAdvanced_IsValidTank(tank))
	{
		return;
	}

	if (SkillAdvanced_IsRockWeapon(weapon) || SkillAdvanced_IsTankRock(attackerEntity))
	{
		SkillAdvanced_AnnounceTankRock(tank, victim);
	}
	else if (SkillAdvanced_IsTankClawWeapon(weapon))
	{
		SkillAdvanced_RegisterTankPunchVictim(tank, victim);
	}
	else if (explicitHittable || implicitHittable || tankHittableFallback ||
		SkillAdvanced_IsRecentHittable(victim, tank))
	{
		// 非爪击、非石头的 Tank 伤害视为打铁候选；实际播报要等
		// player_incapacitated_start 事件确认。
		SkillAdvanced_MarkRecentHittable(victim, tank);
	}
}

void SkillAdvanced_TrackChargerGunDamage(Event event, int charger)
{
	if (!SkillAdvanced_g_hCvarEnable.BoolValue || !SkillAdvanced_g_hCvarChargerTeamKill.BoolValue ||
		!SkillAdvanced_IsValidInfected(charger) || SkillAdvanced_GetZombieClass(charger) != SkillAdvanced_ZC_CHARGER ||
		SkillAdvanced_g_bChargerChargeHitTarget[charger])
	{
		return;
	}

	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	if (!SkillAdvanced_IsValidSurvivor(attacker))
	{
		return;
	}

	char weapon[64];
	event.GetString("weapon", weapon, sizeof(weapon));
	int damageType = event.GetInt("type");
	if (!SkillAdvanced_IsChargerFirearm(weapon, damageType))
	{
		return;
	}

	int damage = event.GetInt("dmg_health");
	if (damage <= 0)
	{
		return;
	}

	float now = GetGameTime();
	bool charging = SkillAdvanced_IsChargerCharging(charger);
	if (charging && !SkillAdvanced_g_bChargerChargeActive[charger])
	{
		// 某些服务器在首次伤害事件前不会触发 charger_charge_start/ability_charge，
		// 这里提供事件缺失时的备用判定。
		SkillAdvanced_BeginChargerCharge(charger);
	}

	// The charge window ends at impact or when the game ends charging. Carrying
	// a survivor must not reopen it, and post-charge damage has no grace period.
	if (!charging && SkillAdvanced_g_bChargerChargeActive[charger])
	{
		SkillAdvanced_EndChargerCharge(charger);
	}
	bool inChargeWindow = charging && SkillAdvanced_IsChargerChargeWindow(charger, now);
	if (inChargeWindow)
	{
		SkillAdvanced_g_bChargerGunTracking[charger] = true;
		SkillAdvanced_g_fChargerLastChargingGun[charger] = now;
	}

	if (!inChargeWindow)
	{
		return;
	}

	SkillAdvanced_g_iChargerGunDamage[charger][attacker] += damage;
	SkillAdvanced_g_iChargerLastGunAttacker[charger] = attacker;

	bool shotgun = (damageType & DMG_BUCKSHOT) != 0 ||
		StrContains(weapon, "shotgun", false) >= 0;
	if (!shotgun || !SkillAdvanced_g_bChargerGunLastShotgun[charger][attacker] ||
		SkillAdvanced_g_fChargerGunLastShot[charger][attacker] == 0.0 ||
		now - SkillAdvanced_g_fChargerGunLastShot[charger][attacker] > SkillAdvanced_CHARGER_TEAMKILL_SHOT_TIME)
	{
		SkillAdvanced_g_iChargerGunShots[charger][attacker]++;
	}
	SkillAdvanced_g_fChargerGunLastShot[charger][attacker] = now;
	SkillAdvanced_g_bChargerGunLastShotgun[charger][attacker] = shotgun;

	if (event.GetInt("health", 1) <= 0)
	{
		SkillAdvanced_g_bChargerGunLethal[charger] = true;
		SkillAdvanced_g_bChargerGunLethalDuringCharge[charger] = inChargeWindow;
		SkillAdvanced_g_iChargerGunLethalAttacker[charger] = attacker;
	}
}

void SkillAdvanced_ReportChargerGunTeamKill(int charger, int deathAttacker)
{
	if (!SkillAdvanced_g_hCvarEnable.BoolValue || !SkillAdvanced_g_hCvarChargerTeamKill.BoolValue ||
		!SkillAdvanced_g_bChargerGunLethal[charger] || !SkillAdvanced_g_bChargerGunLethalDuringCharge[charger])
	{
		return;
	}

	int attacker = SkillAdvanced_g_iChargerGunLethalAttacker[charger];
	if (!SkillAdvanced_IsValidSurvivor(attacker) || SkillAdvanced_g_iChargerGunDamage[charger][attacker] <= 0)
	{
		attacker = deathAttacker;
	}
	if ((!SkillAdvanced_IsValidSurvivor(attacker) || SkillAdvanced_g_iChargerGunDamage[charger][attacker] <= 0) &&
		SkillAdvanced_IsValidSurvivor(SkillAdvanced_g_iChargerLastGunAttacker[charger]))
	{
		attacker = SkillAdvanced_g_iChargerLastGunAttacker[charger];
	}

	if (!SkillAdvanced_IsValidSurvivor(attacker) || SkillAdvanced_g_iChargerGunDamage[charger][attacker] <= 0)
	{
		return;
	}

	int contributors;
	for (int survivor = 1; survivor <= MaxClients; survivor++)
	{
		if (SkillAdvanced_IsValidSurvivor(survivor) && SkillAdvanced_g_iChargerGunDamage[charger][survivor] > 0)
		{
			contributors++;
		}
	}

	if (contributors <= 0)
	{
		return;
	}

	int damage = SkillAdvanced_g_iChargerGunDamage[charger][attacker];
	int shots = SkillAdvanced_g_iChargerGunShots[charger][attacker];
	if (shots < 1)
	{
		shots = 1;
	}

	char shotSuffix[2];
	strcopy(shotSuffix, sizeof(shotSuffix), shots == 1 ? "" : "s");

	if (contributors == 1)
	{
		CPrintToChatAll("%t", "Advanced_ChargerGunSolo", attacker, charger, damage, shots, shotSuffix);
		return;
	}

	char assists[256];
	assists[0] = '\0';
	int assistCount;
	for (int survivor = 1; survivor <= MaxClients; survivor++)
	{
		if (survivor == attacker || !SkillAdvanced_IsValidSurvivor(survivor) ||
			SkillAdvanced_g_iChargerGunDamage[charger][survivor] <= 0)
		{
			continue;
		}

		int assistShots = SkillAdvanced_g_iChargerGunShots[charger][survivor];
		if (assistShots < 1)
		{
			assistShots = 1;
		}

		char assist[64];
		char assistSuffix[2];
		strcopy(assistSuffix, sizeof(assistSuffix), assistShots == 1 ? "" : "s");
		FormatEx(assist, sizeof(assist), "%N (%d/%d shot%s)", survivor,
			SkillAdvanced_g_iChargerGunDamage[charger][survivor], assistShots, assistSuffix);

		if (assistCount > 0)
		{
			StrCat(assists, sizeof(assists), ", ");
		}
		StrCat(assists, sizeof(assists), assist);
		assistCount++;
	}

	CPrintToChatAll("%t", "Advanced_ChargerGunTeam", attacker, charger, damage, shots, shotSuffix, assists);
}

public void SkillAdvanced_Event_PlayerIncapStart(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	if (!SkillAdvanced_IsValidSurvivor(victim))
	{
		return;
	}

	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	int attackerEntity = event.GetInt("attackerentid", -1);
	char weapon[64];
	event.GetString("weapon", weapon, sizeof(weapon));
	bool tankHittableFallback = SkillAdvanced_IsTankHittableFallback(attacker, weapon);
	bool missingSource = attacker <= 0 && attackerEntity <= 0 && weapon[0] == '\0';
	bool explicitHittable = SkillAdvanced_IsHittableEntity(attackerEntity) ||
		SkillAdvanced_IsRecentHittableEntity(attackerEntity) ||
		SkillAdvanced_IsHittableEntity(attacker) ||
		SkillAdvanced_IsRecentHittableEntity(attacker);
	int tank = SkillAdvanced_ResolveTank(attacker, attackerEntity);

	if (!SkillAdvanced_IsValidTank(tank) && explicitHittable)
	{
		tank = SkillAdvanced_GetLatestHittableTank();
	}
	if (!SkillAdvanced_IsValidTank(tank) && tankHittableFallback)
	{
		// 兼容 l4d2_hittable_control 对攻击者字段的改写。
		tank = attacker;
	}
	bool implicitHittable = false;
	if (!SkillAdvanced_IsValidTank(tank) && missingSource)
	{
		tank = SkillAdvanced_GetLatestHittableTank();
		implicitHittable = SkillAdvanced_IsValidTank(tank);
	}
	if (!SkillAdvanced_IsValidTank(tank))
	{
		tank = SkillAdvanced_GetRecentHittableTank(victim);
	}

	if (!SkillAdvanced_IsValidTank(tank))
	{
		return;
	}

	if (SkillAdvanced_IsRockWeapon(weapon) || SkillAdvanced_IsTankRock(attackerEntity))
	{
		SkillAdvanced_AnnounceTankRock(tank, victim);
	}
	else if (SkillAdvanced_IsTankClawWeapon(weapon))
	{
		SkillAdvanced_RegisterTankPunchVictim(tank, victim);
	}
	else if (explicitHittable || implicitHittable || tankHittableFallback ||
		SkillAdvanced_IsRecentHittable(victim, tank))
	{
		SkillAdvanced_AnnounceTankHittable(tank, victim);
	}
}

public void SkillAdvanced_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client > 0 && client <= MaxClients)
	{
		if (SkillAdvanced_g_bChargerGunLethal[client])
		{
			int attacker = GetClientOfUserId(event.GetInt("attacker"));
			SkillAdvanced_ReportChargerGunTeamKill(client, attacker);
		}

		SkillAdvanced_ResetClientState(client);
	}
}

public void SkillAdvanced_Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client > 0 && client <= MaxClients)
	{
		SkillAdvanced_ResetClientState(client);
	}
}

public Action SkillAdvanced_OnTakeDamagePre(
	int victim,
	int &attacker,
	int &inflictor,
	float &damage,
	int &damagetype)
{
	if (damage <= 0.0 || !SkillAdvanced_IsValidSurvivor(victim))
	{
		return Plugin_Continue;
	}

	// 在其它伤害钩子改写 attacker/inflictor 前，先记录原始物理实体；
	// l4d2_hittable_control 会改写物理物体造成的伤害。
	bool explicitHittable = SkillAdvanced_IsHittableEntity(attacker) ||
		SkillAdvanced_IsRecentHittableEntity(attacker) ||
		SkillAdvanced_IsHittableEntity(inflictor) ||
		SkillAdvanced_IsRecentHittableEntity(inflictor);
	int tank = SkillAdvanced_ResolveTank(attacker, inflictor);
	if (!SkillAdvanced_IsValidTank(tank) && explicitHittable)
	{
		tank = SkillAdvanced_GetLatestHittableTank();
	}

	if (SkillAdvanced_IsValidTank(tank) && explicitHittable && !SkillAdvanced_IsTankRock(inflictor))
	{
		SkillAdvanced_MarkRecentHittable(victim, tank);
	}

	return Plugin_Continue;
}

public void SkillAdvanced_OnTakeDamagePost(
	int victim,
	int attacker,
	int inflictor,
	float damage,
	int damagetype,
	int weapon,
	const float damageForce[3],
	const float damagePosition[3])
{
	if (SkillAdvanced_IsValidInfected(victim) && SkillAdvanced_GetZombieClass(victim) == SkillAdvanced_ZC_CHARGER &&
		!SkillAdvanced_g_bChargerChargeHitTarget[victim] &&
		SkillAdvanced_IsValidSurvivor(attacker) &&
		SkillAdvanced_IsLikelyChargerFirearmDamage(inflictor, damagetype) &&
		(SkillAdvanced_IsChargerCharging(victim) || SkillAdvanced_g_bChargerCarrying[victim]))
	{
		if (!SkillAdvanced_g_bChargerChargeActive[victim])
		{
			SkillAdvanced_BeginChargerCharge(victim);
		}
		SkillAdvanced_g_bChargerGunTracking[victim] = true;
		SkillAdvanced_g_fChargerLastChargingGun[victim] = GetGameTime();
		return;
	}

	if (damage <= 0.0 || !SkillAdvanced_IsValidSurvivor(victim))
	{
		return;
	}

	int tank = SkillAdvanced_ResolveTank(attacker, inflictor);
	bool explicitHittable = SkillAdvanced_IsHittableEntity(attacker) ||
		SkillAdvanced_IsRecentHittableEntity(attacker) ||
		SkillAdvanced_IsHittableEntity(inflictor) ||
		SkillAdvanced_IsRecentHittableEntity(inflictor);
	if (!SkillAdvanced_IsValidTank(tank) && explicitHittable)
	{
		tank = SkillAdvanced_GetLatestHittableTank();
	}
	bool implicitHittable = false;
	if (!SkillAdvanced_IsValidTank(tank) && attacker <= 0 && inflictor <= 0)
	{
		tank = SkillAdvanced_GetLatestHittableTank();
		implicitHittable = SkillAdvanced_IsValidTank(tank);
	}
	if (!SkillAdvanced_IsValidTank(tank))
	{
		return;
	}

	if (SkillAdvanced_IsTankRock(inflictor))
	{
		SkillAdvanced_AnnounceTankRock(tank, victim);
	}
	else if (explicitHittable || implicitHittable)
	{
		SkillAdvanced_MarkRecentHittable(victim, tank);
	}
}

public Action SkillAdvanced_Timer_CheckMultiControl(Handle timer)
{
	if (SkillAdvanced_g_bRoundEnded || !SkillAdvanced_g_hCvarEnable.BoolValue || !SkillAdvanced_g_hCvarMultiControl.BoolValue)
	{
		SkillAdvanced_ResetControlState();
		return Plugin_Continue;
	}

	int controlCount = 0;
	for (int infected = 1; infected <= MaxClients; infected++)
	{
		if (!SkillAdvanced_IsValidAliveInfected(infected))
		{
			continue;
		}

		int victim = SkillAdvanced_GetControlVictim(infected);
		if (SkillAdvanced_IsValidSurvivor(victim))
		{
			controlCount++;
		}
	}

	int aliveSurvivors = SkillAdvanced_CountAliveSurvivors();

	if (controlCount < SkillAdvanced_MULTI_CONTROL_MIN)
	{
		if (SkillAdvanced_g_hCvarRoundEnd.BoolValue && !SkillAdvanced_g_bControlRoundEndAnnounced && aliveSurvivors > 0 && controlCount >= aliveSurvivors)
		{
			SkillAdvanced_AnnounceControlRoundEnd();
		}

		SkillAdvanced_ResetControlMilestones();
		return Plugin_Continue;
	}

	int previousCount = SkillAdvanced_g_iControlCount;
	if (controlCount > previousCount)
	{
		int target = controlCount < SkillAdvanced_MULTI_CONTROL_MAX ? controlCount : SkillAdvanced_MULTI_CONTROL_MAX;
		for (int level = SkillAdvanced_g_iControlAnnounced + 1; level <= target; level++)
		{
			if (level >= SkillAdvanced_MULTI_CONTROL_MIN)
			{
				CPrintToChatAll("%t", "Advanced_MultiControl", level);
			}
		}
		SkillAdvanced_g_iControlAnnounced = target;
	}

	SkillAdvanced_g_iControlCount = controlCount;

	if (SkillAdvanced_g_hCvarRoundEnd.BoolValue && !SkillAdvanced_g_bControlRoundEndAnnounced && aliveSurvivors > 0 && controlCount >= aliveSurvivors)
	{
		SkillAdvanced_AnnounceControlRoundEnd();
	}

	return Plugin_Continue;
}

void SkillAdvanced_AnnounceControlRoundEnd()
{
	// A loaded but disabled music box will not announce a multi-control wipe.
	ConVar musicBoxEnabled = FindConVar("l4d2_musicbox_enable");
	if (!LibraryExists("l4d2_musicbox") || musicBoxEnabled == null ||
		!musicBoxEnabled.BoolValue)
	{
		CPrintToChatAll("%t", "Advanced_RoundEnd");
	}
	SkillAdvanced_g_bControlRoundEndAnnounced = true;
}

void SkillAdvanced_StartControlTimer()
{
	if (SkillAdvanced_g_hControlTimer != null)
	{
		return;
	}

	SkillAdvanced_g_hControlTimer = CreateTimer(
		SkillAdvanced_CONTROL_SCAN_INTERVAL,
		SkillAdvanced_Timer_CheckMultiControl,
		_,
		TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action SkillAdvanced_Timer_HookExistingHittables(Handle timer)
{
	SkillAdvanced_HookExistingHittables();
	return Plugin_Stop;
}

public Action SkillAdvanced_Timer_ResetCharger(Handle timer, int userid)
{
	int charger = GetClientOfUserId(userid);
	if (charger > 0 && charger <= MaxClients)
	{
		SkillAdvanced_g_hChargerReset[charger] = null;
		SkillAdvanced_ResetChargerState(charger, false);
	}
	return Plugin_Stop;
}

public Action SkillAdvanced_Timer_ResetBoomer(Handle timer, int userid)
{
	int boomer = GetClientOfUserId(userid);
	if (boomer > 0 && boomer <= MaxClients)
	{
		SkillAdvanced_g_hBoomerReset[boomer] = null;
		SkillAdvanced_ResetBoomerState(boomer, false);
	}
	return Plugin_Stop;
}

public Action SkillAdvanced_Timer_ResetTankPunch(Handle timer, int userid)
{
	int tank = GetClientOfUserId(userid);
	if (tank > 0 && tank <= MaxClients)
	{
		SkillAdvanced_g_hTankPunchReset[tank] = null;
		SkillAdvanced_ResetTankPunchState(tank, false);
	}
	return Plugin_Stop;
}

public void SkillAdvanced_OnHittableSpawned(int entity)
{
	SkillAdvanced_HookHittable(entity);
}

public void SkillAdvanced_OnHittableHitByTank(const char[] output, int caller, int activator, float delay)
{
	if (caller < 0 || caller >= SkillAdvanced_MAX_EDICTS)
	{
		return;
	}

	int tank = activator;
	if (!SkillAdvanced_IsValidTank(tank))
	{
		tank = SkillAdvanced_GetLatestHittableTank();
	}
	if (!SkillAdvanced_IsValidTank(tank))
	{
		tank = SkillAdvanced_FindAnyTank();
	}

	if (!SkillAdvanced_IsValidTank(tank))
	{
		return;
	}

	SkillAdvanced_RememberHittableTank(caller, tank);
}

public void SkillAdvanced_OnHittableTouchPost(int entity, int other)
{
	if (!SkillAdvanced_IsValidSurvivor(other))
	{
		return;
	}

	// 物理物体命中幸存者后，player_hurt 可能已经丢失 attackerentid。
	// 保留“受害者 -> Tank”的直接关联，供随后 incap 事件使用。
	int tank = SkillAdvanced_GetRecentHittableEntityTank(entity);
	if (SkillAdvanced_IsValidTank(tank))
	{
		SkillAdvanced_MarkRecentHittable(other, tank);
	}
}

public void SkillAdvanced_OnHittableTakeDamagePost(int victim, int attacker, int inflictor, float damage, int damagetype)
{
	if (victim < 0 || victim >= SkillAdvanced_MAX_EDICTS || !SkillAdvanced_IsHittableEntity(victim))
	{
		return;
	}

	// 某些地图不会稳定触发 OnHitByTank。物理伤害钩子作为第二判定来源：
	// 直接由 Tank 造成的伤害可以确定归属，连续物理碰撞则继承攻击者缓存的 Tank。
	int tank = SkillAdvanced_ResolveTank(attacker, inflictor);
	if (!SkillAdvanced_IsValidTank(tank) && !SkillAdvanced_IsValidSurvivor(attacker))
	{
		// 在伤害回调中，可能只剩下物理物体实体本身可供识别。
		tank = SkillAdvanced_GetRecentHittableEntityTank(victim);
	}
	if (SkillAdvanced_IsValidTank(tank))
	{
		SkillAdvanced_RememberHittableTank(victim, tank);
	}
}

void SkillAdvanced_RememberHittableTank(int entity, int tank)
{
	if (entity < 0 || entity >= SkillAdvanced_MAX_EDICTS || !SkillAdvanced_IsValidTank(tank))
	{
		return;
	}

	float now = GetGameTime();
	SkillAdvanced_g_iLastHittableTankByEntity[entity] = tank;
	SkillAdvanced_g_fLastHittableEntityHit[entity] = now;
	SkillAdvanced_g_iLastHittableOwnerTank = tank;
	SkillAdvanced_g_fLastHittableOwnerHit = now;
}

void SkillAdvanced_RegisterChargerVictim(int charger, int victim)
{
	if (!SkillAdvanced_g_hCvarEnable.BoolValue || !SkillAdvanced_g_hCvarCharger.BoolValue ||
		!SkillAdvanced_IsValidInfected(charger) || SkillAdvanced_GetZombieClass(charger) != SkillAdvanced_ZC_CHARGER ||
		!SkillAdvanced_IsValidSurvivor(victim))
	{
		return;
	}

	float now = GetGameTime();
	if (SkillAdvanced_g_fChargerLastHit[charger] > 0.0 &&
		now - SkillAdvanced_g_fChargerLastHit[charger] > SkillAdvanced_g_hCvarChargerWindow.FloatValue)
	{
		SkillAdvanced_ResetChargerState(charger);
	}

	SkillAdvanced_g_fChargerLastHit[charger] = now;
	if (!SkillAdvanced_g_bChargerVictim[charger][victim])
	{
		SkillAdvanced_g_bChargerVictim[charger][victim] = true;
		SkillAdvanced_g_iChargerVictimCount[charger]++;

		SkillAdvanced_AnnounceChargerMilestone(charger, SkillAdvanced_g_iChargerVictimCount[charger]);
	}

	delete SkillAdvanced_g_hChargerReset[charger];
	SkillAdvanced_g_hChargerReset[charger] = CreateTimer(
		SkillAdvanced_g_hCvarChargerWindow.FloatValue,
		SkillAdvanced_Timer_ResetCharger,
		GetClientUserId(charger),
		TIMER_FLAG_NO_MAPCHANGE);
}

void SkillAdvanced_RegisterBoomerVictim(int boomer, int victim)
{
	if (!SkillAdvanced_g_hCvarEnable.BoolValue || !SkillAdvanced_g_hCvarBoomer.BoolValue ||
		!SkillAdvanced_IsValidInfected(boomer) || SkillAdvanced_GetZombieClass(boomer) != SkillAdvanced_ZC_BOOMER ||
		!SkillAdvanced_IsValidSurvivor(victim))
	{
		return;
	}

	float now = GetGameTime();
	if (SkillAdvanced_g_fBoomerLastHit[boomer] > 0.0 &&
		now - SkillAdvanced_g_fBoomerLastHit[boomer] > SkillAdvanced_g_hCvarBoomerWindow.FloatValue)
	{
		SkillAdvanced_ResetBoomerState(boomer);
	}

	SkillAdvanced_g_fBoomerLastHit[boomer] = now;
	if (!SkillAdvanced_g_bBoomerVictim[boomer][victim])
	{
		SkillAdvanced_g_bBoomerVictim[boomer][victim] = true;
		SkillAdvanced_g_iBoomerVictimCount[boomer]++;

		SkillAdvanced_AnnounceBoomerMilestone(boomer, SkillAdvanced_g_iBoomerVictimCount[boomer]);
	}

	delete SkillAdvanced_g_hBoomerReset[boomer];
	SkillAdvanced_g_hBoomerReset[boomer] = CreateTimer(
		SkillAdvanced_g_hCvarBoomerWindow.FloatValue,
		SkillAdvanced_Timer_ResetBoomer,
		GetClientUserId(boomer),
		TIMER_FLAG_NO_MAPCHANGE);
}

void SkillAdvanced_RegisterTankPunchVictim(int tank, int victim)
{
	if (!SkillAdvanced_g_hCvarEnable.BoolValue || !SkillAdvanced_g_hCvarTankPunch.BoolValue ||
		!SkillAdvanced_IsValidTank(tank) || !SkillAdvanced_IsValidSurvivor(victim))
	{
		return;
	}

	float now = GetGameTime();
	if (SkillAdvanced_g_fTankPunchLastHit[tank] > 0.0 &&
		now - SkillAdvanced_g_fTankPunchLastHit[tank] > SkillAdvanced_g_hCvarTankPunchWindow.FloatValue)
	{
		SkillAdvanced_ResetTankPunchState(tank);
	}

	SkillAdvanced_g_fTankPunchLastHit[tank] = now;
	if (!SkillAdvanced_g_bTankPunchVictim[tank][victim])
	{
		SkillAdvanced_g_bTankPunchVictim[tank][victim] = true;
		SkillAdvanced_g_iTankPunchVictimCount[tank]++;

		SkillAdvanced_AnnounceTankPunchMilestone(tank, SkillAdvanced_g_iTankPunchVictimCount[tank]);
	}

	delete SkillAdvanced_g_hTankPunchReset[tank];
	SkillAdvanced_g_hTankPunchReset[tank] = CreateTimer(
		SkillAdvanced_g_hCvarTankPunchWindow.FloatValue,
		SkillAdvanced_Timer_ResetTankPunch,
		GetClientUserId(tank),
		TIMER_FLAG_NO_MAPCHANGE);
}

void SkillAdvanced_AnnounceChargerMilestone(int charger, int count)
{
	if (count < SkillAdvanced_MULTI_CONTROL_MIN || count > SkillAdvanced_MULTI_CONTROL_MAX ||
		count <= SkillAdvanced_g_iChargerAnnounced[charger])
	{
		return;
	}

	for (int level = SkillAdvanced_g_iChargerAnnounced[charger] + 1; level <= count; level++)
	{
		if (level >= SkillAdvanced_MULTI_CONTROL_MIN)
		{
			CPrintToChatAll("%t", "Advanced_ChargerMulti", charger, level);
		}
	}
	SkillAdvanced_g_iChargerAnnounced[charger] = count;
}

void SkillAdvanced_AnnounceBoomerMilestone(int boomer, int count)
{
	if (count < SkillAdvanced_MULTI_CONTROL_MIN || count > SkillAdvanced_MULTI_CONTROL_MAX ||
		count <= SkillAdvanced_g_iBoomerAnnounced[boomer])
	{
		return;
	}

	ConVar reportEnabled = FindConVar("sm_skill_report_enable");
	ConVar reportFlags = FindConVar("sm_skill_report_flags");
	ConVar vomitNumber = FindConVar("sm_skill_vomit_number");
	for (int level = SkillAdvanced_g_iBoomerAnnounced[boomer] + 1; level <= count; level++)
	{
		if (level >= SkillAdvanced_MULTI_CONTROL_MIN)
		{
			// The original report handles vomits at or above its configured threshold.
			if (reportEnabled == null || reportFlags == null || vomitNumber == null ||
				!reportEnabled.BoolValue || !(reportFlags.IntValue & (1 << 20)) ||
				level < vomitNumber.IntValue)
			{
				CPrintToChatAll("%t", "Advanced_BoomerMulti", boomer, level);
			}
		}
	}
	SkillAdvanced_g_iBoomerAnnounced[boomer] = count;
}

void SkillAdvanced_AnnounceTankPunchMilestone(int tank, int count)
{
	if (count < SkillAdvanced_MULTI_CONTROL_MIN || count > SkillAdvanced_MULTI_CONTROL_MAX ||
		count <= SkillAdvanced_g_iTankPunchAnnounced[tank])
	{
		return;
	}

	for (int level = SkillAdvanced_g_iTankPunchAnnounced[tank] + 1; level <= count; level++)
	{
		if (level >= SkillAdvanced_MULTI_CONTROL_MIN)
		{
			CPrintToChatAll("%t", "Advanced_TankPunchMulti", tank, level);
		}
	}
	SkillAdvanced_g_iTankPunchAnnounced[tank] = count;
}

void SkillAdvanced_AnnounceTankRock(int tank, int victim)
{
	if (!SkillAdvanced_g_hCvarEnable.BoolValue || !SkillAdvanced_g_hCvarTankRock.BoolValue ||
		!SkillAdvanced_IsValidTank(tank) || !SkillAdvanced_IsValidSurvivor(victim))
	{
		return;
	}

	float now = GetGameTime();
	if (SkillAdvanced_g_iLastRockTank[victim] == tank &&
		now - SkillAdvanced_g_fLastRockAnnounce[victim] < SkillAdvanced_DAMAGE_DEDUPE_TIME)
	{
		return;
	}

	SkillAdvanced_g_iLastRockTank[victim] = tank;
	SkillAdvanced_g_fLastRockAnnounce[victim] = now;
	CPrintToChatAll("%t", "Advanced_TankRockHit", tank, victim);
}

void SkillAdvanced_AnnounceTankHittable(int tank, int victim)
{
	if (!SkillAdvanced_g_hCvarEnable.BoolValue || !SkillAdvanced_g_hCvarTankHittable.BoolValue ||
		!SkillAdvanced_IsValidTank(tank) || !SkillAdvanced_IsValidSurvivor(victim))
	{
		return;
	}

	float now = GetGameTime();
	if (SkillAdvanced_g_iLastHittableTank[victim] == tank &&
		now - SkillAdvanced_g_fLastHittableAnnounce[victim] < SkillAdvanced_HITTABLE_DEDUPE_TIME)
	{
		return;
	}

	SkillAdvanced_g_iLastHittableTank[victim] = tank;
	SkillAdvanced_g_fLastHittableAnnounce[victim] = now;
	CPrintToChatAll("%t", "Advanced_TankHittableIncap", tank, victim);
}

void SkillAdvanced_MarkRecentHittable(int victim, int tank)
{
	if (!SkillAdvanced_IsValidSurvivor(victim) || !SkillAdvanced_IsValidTank(tank))
	{
		return;
	}

	SkillAdvanced_g_iRecentHittableTank[victim] = tank;
	SkillAdvanced_g_fRecentHittableTime[victim] = GetGameTime();
}

int SkillAdvanced_GetRecentHittableTank(int victim)
{
	if (!SkillAdvanced_IsValidSurvivor(victim) || !SkillAdvanced_IsRecentHittable(victim, 0))
	{
		return 0;
	}

	return SkillAdvanced_g_iRecentHittableTank[victim];
}

bool SkillAdvanced_IsRecentHittable(int victim, int tank)
{
	if (!SkillAdvanced_IsValidSurvivor(victim) || !SkillAdvanced_IsValidTank(SkillAdvanced_g_iRecentHittableTank[victim]))
	{
		return false;
	}

	if (GetGameTime() - SkillAdvanced_g_fRecentHittableTime[victim] > SkillAdvanced_HITTABLE_OWNER_TIME)
	{
		return false;
	}

	return tank == 0 || SkillAdvanced_g_iRecentHittableTank[victim] == tank;
}

bool SkillAdvanced_IsRecentHittableEntity(int entity)
{
	if (entity < 0 || entity >= SkillAdvanced_MAX_EDICTS ||
		!SkillAdvanced_IsValidTank(SkillAdvanced_g_iLastHittableTankByEntity[entity]))
	{
		return false;
	}

	return GetGameTime() - SkillAdvanced_g_fLastHittableEntityHit[entity] <= SkillAdvanced_HITTABLE_OWNER_TIME;
}

int SkillAdvanced_GetRecentHittableEntityTank(int entity)
{
	if (entity < 0 || entity >= SkillAdvanced_MAX_EDICTS ||
		GetGameTime() - SkillAdvanced_g_fLastHittableEntityHit[entity] > SkillAdvanced_HITTABLE_OWNER_TIME)
	{
		return 0;
	}

	int tank = SkillAdvanced_g_iLastHittableTankByEntity[entity];
	return SkillAdvanced_IsValidTank(tank) ? tank : 0;
}

int SkillAdvanced_GetLatestHittableTank()
{
	if (SkillAdvanced_IsValidTank(SkillAdvanced_g_iLastHittableOwnerTank) &&
		GetGameTime() - SkillAdvanced_g_fLastHittableOwnerHit <= SkillAdvanced_HITTABLE_OWNER_TIME)
	{
		return SkillAdvanced_g_iLastHittableOwnerTank;
	}

	return 0;
}

int SkillAdvanced_ResolveTank(int attacker, int inflictor)
{
	if (SkillAdvanced_IsValidTank(attacker))
	{
		return attacker;
	}

	if (SkillAdvanced_IsTankRock(inflictor))
	{
		int owner = SkillAdvanced_GetEntityPropEntSafe(inflictor, Prop_Data, "m_hOwnerEntity");
		if (!SkillAdvanced_IsValidTank(owner))
		{
			owner = SkillAdvanced_GetEntityPropEntSafe(inflictor, Prop_Data, "m_hThrower");
		}
		if (SkillAdvanced_IsValidTank(owner))
		{
			return owner;
		}
	}

	int owner = SkillAdvanced_GetRecentHittableEntityTank(inflictor);
	if (SkillAdvanced_IsValidTank(owner))
	{
		return owner;
	}

	owner = SkillAdvanced_GetRecentHittableEntityTank(attacker);
	if (SkillAdvanced_IsValidTank(owner))
	{
		return owner;
	}

	return 0;
}

int SkillAdvanced_GetControlVictim(int infected)
{
	int victim = -1;

	switch (SkillAdvanced_GetZombieClass(infected))
	{
		case 1:
		{
			victim = SkillAdvanced_GetEntityPropEntSafe(infected, Prop_Send, "m_tongueVictim");
		}
		case 3:
		{
			victim = SkillAdvanced_GetEntityPropEntSafe(infected, Prop_Send, "m_pounceVictim");
		}
		case 5:
		{
			victim = SkillAdvanced_GetEntityPropEntSafe(infected, Prop_Send, "m_jockeyVictim");
		}
		case SkillAdvanced_ZC_CHARGER:
		{
			victim = SkillAdvanced_GetEntityPropEntSafe(infected, Prop_Send, "m_carryVictim");
			if (!SkillAdvanced_IsValidSurvivor(victim))
			{
				victim = SkillAdvanced_GetEntityPropEntSafe(infected, Prop_Send, "m_pummelVictim");
			}
		}
	}

	return victim;
}

int SkillAdvanced_CountAliveSurvivors()
{
	int count = 0;
	for (int client = 1; client <= MaxClients; client++)
	{
		if (SkillAdvanced_IsValidSurvivor(client) && IsPlayerAlive(client))
		{
			count++;
		}
	}
	return count;
}

void SkillAdvanced_HookExistingHittables()
{
	int entity = -1;
	while ((entity = FindEntityByClassname(entity, "prop_physics*")) != -1)
	{
		SkillAdvanced_HookHittable(entity);
	}

	entity = -1;
	while ((entity = FindEntityByClassname(entity, "physics_prop")) != -1)
	{
		SkillAdvanced_HookHittable(entity);
	}

	entity = -1;
	while ((entity = FindEntityByClassname(entity, "prop_car_alarm")) != -1)
	{
		SkillAdvanced_HookHittable(entity);
	}

	entity = -1;
	while ((entity = FindEntityByClassname(entity, "prop_alarm_car")) != -1)
	{
		SkillAdvanced_HookHittable(entity);
	}
}

void SkillAdvanced_HookHittable(int entity)
{
	if (entity <= MaxClients || entity >= SkillAdvanced_MAX_EDICTS || !SkillAdvanced_IsHittableEntity(entity) ||
		SkillAdvanced_g_bHittableHooked[entity])
	{
		return;
	}

	HookSingleEntityOutput(entity, "OnHitByTank", SkillAdvanced_OnHittableHitByTank);
	SDKHook(entity, SDKHook_OnTakeDamagePost, SkillAdvanced_OnHittableTakeDamagePost);
	SDKHook(entity, SDKHook_TouchPost, SkillAdvanced_OnHittableTouchPost);
	SkillAdvanced_g_bHittableHooked[entity] = true;
}

bool SkillAdvanced_IsHittableClass(const char[] classname)
{
	return StrContains(classname, "prop_physics", false) == 0 ||
		StrEqual(classname, "physics_prop", false) ||
		StrEqual(classname, "prop_car_alarm", false) ||
		StrEqual(classname, "prop_alarm_car", false);
}

bool SkillAdvanced_IsHittableEntity(int entity)
{
	if (entity <= MaxClients || !IsValidEntity(entity))
	{
		return false;
	}

	char classname[64];
	GetEntityClassname(entity, classname, sizeof(classname));

	if (StrEqual(classname, "prop_car_alarm", false) ||
		StrEqual(classname, "prop_alarm_car", false))
	{
		return true;
	}

	if (StrContains(classname, "prop_physics", false) == 0 ||
		StrEqual(classname, "physics_prop", false))
	{
		// 自定义地图上 m_hasTankGlow 的初始化并不一致。这里对所有物理物体都挂钩，
		// 只有实际的 OnHitByTank 输出或 Tank 伤害路径才能创建播报候选。
		return true;
	}

	return false;
}

bool SkillAdvanced_IsTankRock(int entity)
{
	if (entity <= MaxClients || !IsValidEntity(entity))
	{
		return false;
	}

	char classname[32];
	GetEntityClassname(entity, classname, sizeof(classname));
	return StrEqual(classname, "tank_rock", false);
}

bool SkillAdvanced_IsTankClawWeapon(const char[] weapon)
{
	return StrEqual(weapon, "tank_claw", false) ||
		StrEqual(weapon, "weapon_tank_claw", false);
}

bool SkillAdvanced_IsRockWeapon(const char[] weapon)
{
	return StrEqual(weapon, "tank_rock", false);
}

bool SkillAdvanced_IsTankHittableFallback(int attacker, const char[] weapon)
{
	// l4d2_hittable_control 会把幸存者受到的物理伤害的攻击者改为 Tank，
	// 也可能清空原始物理实体。此时唯一可靠的区分方式是 weapon 既不是 claw 也不是 rock。
	// 这个逻辑也刻意接受 AI Tank。
	return SkillAdvanced_IsValidTank(attacker) &&
		!SkillAdvanced_IsTankClawWeapon(weapon) &&
		!SkillAdvanced_IsRockWeapon(weapon);
}

bool SkillAdvanced_IsChargerFirearm(const char[] weapon, int damageType)
{
	if (SkillAdvanced_IsTankClawWeapon(weapon) || SkillAdvanced_IsRockWeapon(weapon) ||
		StrContains(weapon, "melee", false) >= 0)
	{
		return false;
	}

	// 对标准枪械来说，子弹和霰弹伤害是可靠信号。
	if ((damageType & (DMG_BULLET | DMG_BUCKSHOT)) != 0)
	{
		return true;
	}

	// 包含直接命中的榴弹发射器伤害，但不把土制炸弹、火焰或胆汁罐等
	// 一般爆炸伤害算进去。
	if (StrEqual(weapon, "grenade_launcher_projectile", false) ||
		StrEqual(weapon, "grenade_launcher", false))
	{
		return true;
	}

	return StrContains(weapon, "pistol", false) >= 0 ||
		StrContains(weapon, "smg", false) >= 0 ||
		StrContains(weapon, "shotgun", false) >= 0 ||
		StrContains(weapon, "rifle", false) >= 0 ||
		StrContains(weapon, "sniper", false) >= 0;
}

bool SkillAdvanced_IsLikelyChargerFirearmDamage(int inflictor, int damageType)
{
	if ((damageType & (DMG_BULLET | DMG_BUCKSHOT)) != 0)
	{
		return true;
	}

	if (inflictor < 0 || !IsValidEntity(inflictor))
	{
		return false;
	}

	char classname[64];
	GetEntityClassname(inflictor, classname, sizeof(classname));
	return StrContains(classname, "grenade_launcher_projectile", false) >= 0;
}

bool SkillAdvanced_IsChargerCharging(int charger)
{
	if (!SkillAdvanced_IsValidInfected(charger) || SkillAdvanced_GetZombieClass(charger) != SkillAdvanced_ZC_CHARGER)
	{
		return false;
	}

	int ability = SkillAdvanced_GetEntityPropEntSafe(charger, Prop_Send, "m_customAbility");
	return IsValidEntity(ability) && HasEntProp(ability, Prop_Send, "m_isCharging") &&
		GetEntProp(ability, Prop_Send, "m_isCharging") != 0;
}

void SkillAdvanced_BeginChargerCharge(int charger)
{
	if (!SkillAdvanced_IsValidInfected(charger) || SkillAdvanced_GetZombieClass(charger) != SkillAdvanced_ZC_CHARGER)
	{
		return;
	}

	float now = GetGameTime();
	if (SkillAdvanced_g_bChargerChargeActive[charger] &&
		SkillAdvanced_g_fChargerChargeStart[charger] > 0.0 &&
		now - SkillAdvanced_g_fChargerChargeStart[charger] <= SkillAdvanced_CHARGER_TEAMKILL_MAX_CHARGE_TIME)
	{
		// ability_use 和 charger_charge_start 可能描述的是同一次冲锋，
		// 不要因为第二个事件到来就清空已经记录的枪械伤害。
		return;
	}

	SkillAdvanced_g_bChargerChargeHitTarget[charger] = false;
	SkillAdvanced_g_bChargerChargeActive[charger] = true;
	SkillAdvanced_g_fChargerChargeStart[charger] = now;
}

void SkillAdvanced_EndChargerCharge(int charger, bool hitTarget = false)
{
	if (charger <= 0 || charger > MaxClients)
	{
		return;
	}

	if (hitTarget)
	{
		// Keep already confirmed lethal damage while closing this charge now.
		SkillAdvanced_g_bChargerChargeHitTarget[charger] = true;
		SkillAdvanced_g_bChargerChargeActive[charger] = false;
		SkillAdvanced_g_fChargerChargeStart[charger] = 0.0;
		return;
	}

	if (!SkillAdvanced_g_bChargerChargeActive[charger])
	{
		return;
	}

	SkillAdvanced_g_bChargerChargeActive[charger] = false;
	SkillAdvanced_g_bChargerChargeHitTarget[charger] = true;
	SkillAdvanced_g_fChargerChargeStart[charger] = 0.0;
}

bool SkillAdvanced_IsChargerChargeWindow(int charger, float now)
{
	if (charger <= 0 || charger > MaxClients ||
		!SkillAdvanced_g_bChargerChargeActive[charger] ||
		SkillAdvanced_g_bChargerChargeHitTarget[charger] ||
		SkillAdvanced_g_fChargerChargeStart[charger] <= 0.0)
	{
		return false;
	}

	if (now - SkillAdvanced_g_fChargerChargeStart[charger] > SkillAdvanced_CHARGER_TEAMKILL_MAX_CHARGE_TIME)
	{
		SkillAdvanced_g_bChargerChargeActive[charger] = false;
		SkillAdvanced_g_bChargerChargeHitTarget[charger] = true;
		SkillAdvanced_g_fChargerChargeStart[charger] = 0.0;
		return false;
	}

	return true;
}

int SkillAdvanced_GetZombieClass(int client)
{
	if (client <= 0 || client > MaxClients || !IsClientInGame(client) ||
		!HasEntProp(client, Prop_Send, "m_zombieClass"))
	{
		return 0;
	}

	return GetEntProp(client, Prop_Send, "m_zombieClass");
}

int SkillAdvanced_GetEntityPropEntSafe(int entity, PropType type, const char[] prop)
{
	if (entity < 0 || !IsValidEntity(entity) || !HasEntProp(entity, type, prop))
	{
		return -1;
	}

	return GetEntPropEnt(entity, type, prop);
}

bool SkillAdvanced_IsValidSurvivor(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) &&
		GetClientTeam(client) == SkillAdvanced_TEAM_SURVIVOR;
}

bool SkillAdvanced_IsValidInfected(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) &&
		GetClientTeam(client) == SkillAdvanced_TEAM_INFECTED;
}

bool SkillAdvanced_IsValidAliveInfected(int client)
{
	return SkillAdvanced_IsValidInfected(client) && IsPlayerAlive(client);
}

bool SkillAdvanced_IsValidTank(int client)
{
	return SkillAdvanced_IsValidInfected(client) && SkillAdvanced_GetZombieClass(client) == SkillAdvanced_ZC_TANK;
}

int SkillAdvanced_FindAnyTank()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (SkillAdvanced_IsValidTank(client))
		{
			return client;
		}
	}

	return 0;
}

void SkillAdvanced_ResetControlState()
{
	SkillAdvanced_ResetControlMilestones();
	SkillAdvanced_g_bControlRoundEndAnnounced = false;
}

void SkillAdvanced_ResetControlMilestones()
{
	SkillAdvanced_g_iControlCount = 0;
	SkillAdvanced_g_iControlAnnounced = 0;
}

void SkillAdvanced_ResetChargerState(int client, bool cancelTimer = true)
{
	if (client <= 0 || client > MaxClients)
	{
		return;
	}

	if (cancelTimer)
	{
		delete SkillAdvanced_g_hChargerReset[client];
	}
	SkillAdvanced_g_hChargerReset[client] = null;

	SkillAdvanced_g_iChargerVictimCount[client] = 0;
	SkillAdvanced_g_iChargerAnnounced[client] = 0;
	SkillAdvanced_g_fChargerLastHit[client] = 0.0;
	for (int victim = 1; victim <= MaxClients; victim++)
	{
		SkillAdvanced_g_bChargerVictim[client][victim] = false;
	}
}

void SkillAdvanced_ResetChargerGunState(int client)
{
	if (client <= 0 || client > MaxClients)
	{
		return;
	}

	SkillAdvanced_g_bChargerGunTracking[client] = false;
	SkillAdvanced_g_bChargerCarrying[client] = false;
	SkillAdvanced_g_bChargerGunLethal[client] = false;
	SkillAdvanced_g_bChargerGunLethalDuringCharge[client] = false;
	SkillAdvanced_g_iChargerGunLethalAttacker[client] = 0;
	SkillAdvanced_g_iChargerLastGunAttacker[client] = 0;
	SkillAdvanced_g_fChargerLastChargingGun[client] = 0.0;
	SkillAdvanced_g_bChargerChargeActive[client] = false;
	SkillAdvanced_g_bChargerChargeHitTarget[client] = false;
	SkillAdvanced_g_fChargerChargeStart[client] = 0.0;

	for (int survivor = 1; survivor <= MaxClients; survivor++)
	{
		SkillAdvanced_g_iChargerGunDamage[client][survivor] = 0;
		SkillAdvanced_g_iChargerGunShots[client][survivor] = 0;
		SkillAdvanced_g_fChargerGunLastShot[client][survivor] = 0.0;
		SkillAdvanced_g_bChargerGunLastShotgun[client][survivor] = false;
	}
}

void SkillAdvanced_ResetBoomerState(int client, bool cancelTimer = true)
{
	if (client <= 0 || client > MaxClients)
	{
		return;
	}

	if (cancelTimer)
	{
		delete SkillAdvanced_g_hBoomerReset[client];
	}
	SkillAdvanced_g_hBoomerReset[client] = null;

	SkillAdvanced_g_iBoomerVictimCount[client] = 0;
	SkillAdvanced_g_iBoomerAnnounced[client] = 0;
	SkillAdvanced_g_fBoomerLastHit[client] = 0.0;
	for (int victim = 1; victim <= MaxClients; victim++)
	{
		SkillAdvanced_g_bBoomerVictim[client][victim] = false;
	}
}

void SkillAdvanced_ResetTankPunchState(int client, bool cancelTimer = true)
{
	if (client <= 0 || client > MaxClients)
	{
		return;
	}

	if (cancelTimer)
	{
		delete SkillAdvanced_g_hTankPunchReset[client];
	}
	SkillAdvanced_g_hTankPunchReset[client] = null;

	SkillAdvanced_g_iTankPunchVictimCount[client] = 0;
	SkillAdvanced_g_iTankPunchAnnounced[client] = 0;
	SkillAdvanced_g_fTankPunchLastHit[client] = 0.0;
	for (int victim = 1; victim <= MaxClients; victim++)
	{
		SkillAdvanced_g_bTankPunchVictim[client][victim] = false;
	}
}

void SkillAdvanced_ResetClientState(int client)
{
	if (client <= 0 || client > MaxClients)
	{
		return;
	}

	SkillAdvanced_ResetChargerState(client);
	SkillAdvanced_ResetChargerGunState(client);
	SkillAdvanced_ResetBoomerState(client);
	SkillAdvanced_ResetTankPunchState(client);

	SkillAdvanced_g_iRecentHittableTank[client] = 0;
	SkillAdvanced_g_fRecentHittableTime[client] = 0.0;
	SkillAdvanced_g_iLastRockTank[client] = 0;
	SkillAdvanced_g_fLastRockAnnounce[client] = 0.0;
	SkillAdvanced_g_iLastHittableTank[client] = 0;
	SkillAdvanced_g_fLastHittableAnnounce[client] = 0.0;

	for (int owner = 1; owner <= MaxClients; owner++)
	{
		SkillAdvanced_g_bChargerVictim[owner][client] = false;
		SkillAdvanced_g_iChargerGunDamage[owner][client] = 0;
		SkillAdvanced_g_iChargerGunShots[owner][client] = 0;
		SkillAdvanced_g_fChargerGunLastShot[owner][client] = 0.0;
		SkillAdvanced_g_bChargerGunLastShotgun[owner][client] = false;
		SkillAdvanced_g_bBoomerVictim[owner][client] = false;
		SkillAdvanced_g_bTankPunchVictim[owner][client] = false;
	}
}

void SkillAdvanced_ResetAllState()
{
	SkillAdvanced_ResetControlState();

	for (int client = 1; client <= MaxClients; client++)
	{
		SkillAdvanced_ResetChargerState(client);
		SkillAdvanced_ResetChargerGunState(client);
		SkillAdvanced_ResetBoomerState(client);
		SkillAdvanced_ResetTankPunchState(client);
		SkillAdvanced_g_iRecentHittableTank[client] = 0;
		SkillAdvanced_g_fRecentHittableTime[client] = 0.0;
		SkillAdvanced_g_iLastRockTank[client] = 0;
		SkillAdvanced_g_fLastRockAnnounce[client] = 0.0;
		SkillAdvanced_g_iLastHittableTank[client] = 0;
		SkillAdvanced_g_fLastHittableAnnounce[client] = 0.0;

		for (int victim = 1; victim <= MaxClients; victim++)
		{
			SkillAdvanced_g_bChargerVictim[client][victim] = false;
			SkillAdvanced_g_iChargerGunDamage[client][victim] = 0;
			SkillAdvanced_g_iChargerGunShots[client][victim] = 0;
			SkillAdvanced_g_fChargerGunLastShot[client][victim] = 0.0;
			SkillAdvanced_g_bChargerGunLastShotgun[client][victim] = false;
			SkillAdvanced_g_bBoomerVictim[client][victim] = false;
			SkillAdvanced_g_bTankPunchVictim[client][victim] = false;
		}
	}
}

void SkillAdvanced_ResetHittableOwnerCache()
{
	SkillAdvanced_g_iLastHittableOwnerTank = 0;
	SkillAdvanced_g_fLastHittableOwnerHit = 0.0;

	for (int entity = 0; entity < SkillAdvanced_MAX_EDICTS; entity++)
	{
		SkillAdvanced_g_iLastHittableTankByEntity[entity] = 0;
		SkillAdvanced_g_fLastHittableEntityHit[entity] = 0.0;
	}
}
