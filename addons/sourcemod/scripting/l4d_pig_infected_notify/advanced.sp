// Advanced announcements included by the original plugin.


#define PigAdvanced_PLUGIN_NAME "l4d_pig_infected_notify_advanced"
#define PigAdvanced_PLUGIN_VERSION "1.0.0"
#define PigAdvanced_TEAM_SURVIVOR 2
#define PigAdvanced_TEAM_INFECTED 3
#define PigAdvanced_ZC_BOOMER 2
#define PigAdvanced_MAX_EDICTS 2048
#define PigAdvanced_EXPLOSION_WINDOW 0.6
#define PigAdvanced_ALARM_DISTANCE 350.0
#define PigAdvanced_CONTROL_RELEASE_WINDOW 0.25

ConVar PigAdvanced_g_cvEnable;
ConVar PigAdvanced_g_cvAlarm;
ConVar PigAdvanced_g_cvBoomClear;
ConVar PigAdvanced_g_cvWitch;
ConVar PigAdvanced_g_cvBile;
ConVar PigAdvanced_g_cvSteal;

int PigAdvanced_g_boomUserId[MAXPLAYERS + 1];
int PigAdvanced_g_boomKillerUserId[MAXPLAYERS + 1];
char PigAdvanced_g_boomName[MAXPLAYERS + 1][MAX_NAME_LENGTH];
float PigAdvanced_g_boomTime[MAXPLAYERS + 1];
float PigAdvanced_g_boomPos[MAXPLAYERS + 1][3];
bool PigAdvanced_g_boomExploded[MAXPLAYERS + 1];
float PigAdvanced_g_bileTime[MAXPLAYERS + 1][MAXPLAYERS + 1];
bool PigAdvanced_g_bileAnnounced[MAXPLAYERS + 1][MAXPLAYERS + 1];
bool PigAdvanced_g_alarmAnnounced[MAXPLAYERS + 1];
bool PigAdvanced_g_boomClearAnnounced[MAXPLAYERS + 1][MAXPLAYERS + 1];

int PigAdvanced_g_controlVictim[MAXPLAYERS + 1];       // survivor userid, indexed by infected client
int PigAdvanced_g_controlClass[MAXPLAYERS + 1];
int PigAdvanced_g_victimController[MAXPLAYERS + 1];   // infected userid, indexed by survivor client
int PigAdvanced_g_recentController[MAXPLAYERS + 1];
int PigAdvanced_g_recentClass[MAXPLAYERS + 1];
float PigAdvanced_g_recentReleaseTime[MAXPLAYERS + 1];
float PigAdvanced_g_controlReleaseTime[MAXPLAYERS + 1];
int PigAdvanced_g_controlReleaseVictim[MAXPLAYERS + 1];

int PigAdvanced_g_witchAttackers[PigAdvanced_MAX_EDICTS + 1][MAXPLAYERS + 1];

public void PigAdvanced_OnPluginStart()
{
    PigAdvanced_g_cvEnable = CreateConVar(PigAdvanced_PLUGIN_NAME ... "_enable", "1", "Enable plugin", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    PigAdvanced_g_cvAlarm = CreateConVar(PigAdvanced_PLUGIN_NAME ... "_alarm", "1", "Report Boomer-triggered car alarms", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    PigAdvanced_g_cvBoomClear = CreateConVar(PigAdvanced_PLUGIN_NAME ... "_boom_clear", "1", "Report Boomer explosion clearing infected controls", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    PigAdvanced_g_cvWitch = CreateConVar(PigAdvanced_PLUGIN_NAME ... "_witch", "1", "Report infected Witch kills and assists", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    PigAdvanced_g_cvBile = CreateConVar(PigAdvanced_PLUGIN_NAME ... "_bile", "1", "Report teammates biled by shot Boomers", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    PigAdvanced_g_cvSteal = CreateConVar(PigAdvanced_PLUGIN_NAME ... "_steal", "1", "Report infected control steals", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    CreateConVar(PigAdvanced_PLUGIN_NAME ... "_version", PigAdvanced_PLUGIN_VERSION, "Plugin version", FCVAR_NOTIFY | FCVAR_DONTRECORD);
    AutoExecConfig(true, PigAdvanced_PLUGIN_NAME);

    HookEvent("round_start", PigAdvanced_Event_Reset, EventHookMode_PostNoCopy);
    HookEvent("round_end", PigAdvanced_Event_Reset, EventHookMode_PostNoCopy);
    HookEvent("player_spawn", PigAdvanced_Event_PlayerSpawn);
    HookEvent("player_death", PigAdvanced_Event_PlayerDeath);
    HookEvent("boomer_exploded", PigAdvanced_Event_BoomerExploded);
    HookEvent("player_now_it", PigAdvanced_Event_PlayerNowIt);
    HookEvent("infected_hurt", PigAdvanced_Event_InfectedHurt);
    HookEvent("witch_killed", PigAdvanced_Event_WitchKilled);

    HookEvent("tongue_grab", PigAdvanced_Event_ControlStart);
    HookEvent("lunge_pounce", PigAdvanced_Event_ControlStart);
    HookEvent("jockey_ride", PigAdvanced_Event_ControlStart);
    HookEvent("charger_carry_start", PigAdvanced_Event_ControlStart);
    HookEvent("charger_pummel_start", PigAdvanced_Event_ControlStart);
    HookEvent("tongue_release", PigAdvanced_Event_ControlEnd);
    HookEvent("pounce_end", PigAdvanced_Event_ControlEnd);
    HookEvent("jockey_ride_end", PigAdvanced_Event_ControlEnd);
    HookEvent("charger_carry_end", PigAdvanced_Event_ControlEnd);
    HookEvent("charger_pummel_end", PigAdvanced_Event_ControlEnd);

    // Covers a late plugin load while a round is already running.
    int entity = -1;
    while ((entity = FindEntityByClassname(entity, "prop_car_alarm")) != -1)
        HookSingleEntityOutput(entity, "OnCarAlarmStart", PigAdvanced_OnCarAlarmStart);
    while ((entity = FindEntityByClassname(entity, "prop_alarm_car")) != -1)
        HookSingleEntityOutput(entity, "OnCarAlarmStart", PigAdvanced_OnCarAlarmStart);
}

public void PigAdvanced_OnEntityCreated(int entity, const char[] classname)
{
    if (entity <= MaxClients || entity > PigAdvanced_MAX_EDICTS)
        return;

    if (StrEqual(classname, "witch"))
    {
        for (int client = 1; client <= MaxClients; client++)
            PigAdvanced_g_witchAttackers[entity][client] = 0;
    }
    else if (StrEqual(classname, "prop_car_alarm") || StrEqual(classname, "prop_alarm_car"))
    {
        HookSingleEntityOutput(entity, "OnCarAlarmStart", PigAdvanced_OnCarAlarmStart);
    }
}

public void PigAdvanced_OnClientDisconnect(int client)
{
    PigAdvanced_ClearBoomer(client);
    PigAdvanced_ReleaseControl(client, 0);
    for (int survivor = 1; survivor <= MaxClients; survivor++)
    {
        if (PigAdvanced_g_victimController[survivor] == GetClientUserId(client))
            PigAdvanced_g_victimController[survivor] = 0;
    }
    PigAdvanced_g_recentController[client] = 0;
    PigAdvanced_g_victimController[client] = 0;
}

void PigAdvanced_Event_Reset(Event event, const char[] name, bool dontBroadcast)
{
    for (int client = 1; client <= MaxClients; client++)
    {
        PigAdvanced_ClearBoomer(client);
        PigAdvanced_g_controlVictim[client] = 0;
        PigAdvanced_g_controlClass[client] = 0;
        PigAdvanced_g_victimController[client] = 0;
        PigAdvanced_g_recentController[client] = 0;
        PigAdvanced_g_recentReleaseTime[client] = 0.0;
        PigAdvanced_g_controlReleaseTime[client] = 0.0;
    }
    for (int entity = MaxClients + 1; entity <= PigAdvanced_MAX_EDICTS; entity++)
        for (int client = 1; client <= MaxClients; client++)
            PigAdvanced_g_witchAttackers[entity][client] = 0;
}

void PigAdvanced_Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    if (client > 0)
    {
        PigAdvanced_ClearBoomer(client);
        PigAdvanced_ReleaseControl(client, 0);
    }
}

void PigAdvanced_Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int victim = GetClientOfUserId(event.GetInt("userid"));
    if (victim <= 0)
        return;

    // Keep the Boomer record until boomer_exploded and the related callbacks finish.
    if (PigAdvanced_IsInfectedClass(victim, PigAdvanced_ZC_BOOMER))
        PigAdvanced_RecordBoomer(victim, GetClientOfUserId(event.GetInt("attacker")));

    int controller = GetClientOfUserId(PigAdvanced_g_victimController[victim]);
    if (controller > 0)
        PigAdvanced_ReleaseControl(controller, victim);
    PigAdvanced_ReleaseControl(victim, 0);
    PigAdvanced_g_victimController[victim] = 0;
}

void PigAdvanced_RecordBoomer(int boomer, int killer)
{
    if (!PigAdvanced_IsInfectedClass(boomer, PigAdvanced_ZC_BOOMER))
        return;

    int userId = GetClientUserId(boomer);
    if (PigAdvanced_g_boomUserId[boomer] != userId || GetGameTime() - PigAdvanced_g_boomTime[boomer] > PigAdvanced_EXPLOSION_WINDOW)
    {
        for (int victim = 1; victim <= MaxClients; victim++)
        {
            PigAdvanced_g_bileAnnounced[boomer][victim] = false;
            PigAdvanced_g_boomClearAnnounced[boomer][victim] = false;
        }
        PigAdvanced_g_alarmAnnounced[boomer] = false;
        PigAdvanced_g_boomExploded[boomer] = false;
    }

    PigAdvanced_g_boomUserId[boomer] = userId;
    PigAdvanced_g_boomTime[boomer] = GetGameTime();
    GetClientAbsOrigin(boomer, PigAdvanced_g_boomPos[boomer]);
    GetClientName(boomer, PigAdvanced_g_boomName[boomer], sizeof(PigAdvanced_g_boomName[]));
    if (PigAdvanced_IsTeamClient(killer, PigAdvanced_TEAM_SURVIVOR))
        PigAdvanced_g_boomKillerUserId[boomer] = GetClientUserId(killer);
}

void PigAdvanced_Event_BoomerExploded(Event event, const char[] name, bool dontBroadcast)
{
    if (!PigAdvanced_g_cvEnable.BoolValue)
        return;

    int boomer = GetClientOfUserId(event.GetInt("userid"));
    if (boomer <= 0)
        return;

    PigAdvanced_RecordBoomer(boomer, GetClientOfUserId(event.GetInt("attacker")));
    PigAdvanced_g_boomExploded[boomer] = true;
    CreateTimer(0.12, PigAdvanced_Timer_ReportBile, GetClientUserId(boomer), TIMER_FLAG_NO_MAPCHANGE);
}

void PigAdvanced_Event_PlayerNowIt(Event event, const char[] name, bool dontBroadcast)
{
    if (!PigAdvanced_g_cvEnable.BoolValue || !PigAdvanced_g_cvBile.BoolValue || !event.GetBool("exploded") || !event.GetBool("by_boomer"))
        return;

    int victim = GetClientOfUserId(event.GetInt("userid"));
    int boomer = GetClientOfUserId(event.GetInt("attacker"));
    if (!PigAdvanced_IsTeamClient(victim, PigAdvanced_TEAM_SURVIVOR) || boomer <= 0 || !PigAdvanced_IsInfectedClass(boomer, PigAdvanced_ZC_BOOMER))
        return;

    PigAdvanced_g_bileTime[boomer][victim] = GetGameTime();
    PigAdvanced_ReportBile(boomer, victim);
}

Action PigAdvanced_Timer_ReportBile(Handle timer, int userId)
{
    int boomer = GetClientOfUserId(userId);
    if (boomer > 0)
        for (int victim = 1; victim <= MaxClients; victim++)
            PigAdvanced_ReportBile(boomer, victim);
    return Plugin_Stop;
}

void PigAdvanced_ReportBile(int boomer, int victim)
{
    if (!PigAdvanced_g_cvEnable.BoolValue || !PigAdvanced_g_cvBile.BoolValue || !PigAdvanced_IsTeamClient(victim, PigAdvanced_TEAM_SURVIVOR)
        || PigAdvanced_g_bileAnnounced[boomer][victim] || !PigAdvanced_g_boomExploded[boomer]
        || PigAdvanced_g_boomUserId[boomer] != GetClientUserId(boomer)
        || GetGameTime() - PigAdvanced_g_boomTime[boomer] > PigAdvanced_EXPLOSION_WINDOW
        || GetGameTime() - PigAdvanced_g_bileTime[boomer][victim] > PigAdvanced_EXPLOSION_WINDOW)
        return;

    int killer = GetClientOfUserId(PigAdvanced_g_boomKillerUserId[boomer]);
    if (!PigAdvanced_IsTeamClient(killer, PigAdvanced_TEAM_SURVIVOR) || killer == victim)
        return;

    PigAdvanced_g_bileAnnounced[boomer][victim] = true;
    CPrintToChatAll("%t", "Bile Teammate", killer, victim);
}

void PigAdvanced_OnCarAlarmStart(const char[] output, int caller, int activator, float delay)
{
    if (!PigAdvanced_g_cvEnable.BoolValue || !PigAdvanced_g_cvAlarm.BoolValue || !IsValidEntity(caller))
        return;

    // The output identifies the actual alarm car; triggered_car_alarm has no car ID.
    CreateTimer(0.12, PigAdvanced_Timer_ReportAlarm, EntIndexToEntRef(caller), TIMER_FLAG_NO_MAPCHANGE);
}

Action PigAdvanced_Timer_ReportAlarm(Handle timer, int carRef)
{
    int car = EntRefToEntIndex(carRef);
    if (!PigAdvanced_g_cvEnable.BoolValue || !PigAdvanced_g_cvAlarm.BoolValue || car == INVALID_ENT_REFERENCE)
        return Plugin_Stop;

    float carPos[3];
    GetEntPropVector(car, Prop_Send, "m_vecOrigin", carPos);
    int bestBoomer = 0;
    float bestDistance = PigAdvanced_ALARM_DISTANCE;
    for (int boomer = 1; boomer <= MaxClients; boomer++)
    {
        if (PigAdvanced_g_boomUserId[boomer] == 0 || !PigAdvanced_g_boomExploded[boomer] || PigAdvanced_g_alarmAnnounced[boomer]
            || GetClientOfUserId(PigAdvanced_g_boomUserId[boomer]) != boomer
            || GetGameTime() - PigAdvanced_g_boomTime[boomer] > PigAdvanced_EXPLOSION_WINDOW)
            continue;

        int killer = GetClientOfUserId(PigAdvanced_g_boomKillerUserId[boomer]);
        if (!PigAdvanced_IsTeamClient(killer, PigAdvanced_TEAM_SURVIVOR))
            continue;

        float distance = GetVectorDistance(carPos, PigAdvanced_g_boomPos[boomer]);
        if (distance < bestDistance)
        {
            bestDistance = distance;
            bestBoomer = boomer;
        }
    }

    if (bestBoomer > 0)
    {
        PigAdvanced_g_alarmAnnounced[bestBoomer] = true;
        int killer = GetClientOfUserId(PigAdvanced_g_boomKillerUserId[bestBoomer]);
        CPrintToChatAll("%t", "Boomer Alarm", killer, PigAdvanced_g_boomName[bestBoomer]);
    }
    return Plugin_Stop;
}

void PigAdvanced_OnStagger(int target, int source)
{
    if (!PigAdvanced_g_cvEnable.BoolValue || !PigAdvanced_g_cvBoomClear.BoolValue || !PigAdvanced_IsTeamClient(target, PigAdvanced_TEAM_INFECTED)
        || source <= 0 || source > MaxClients || PigAdvanced_g_boomUserId[source] == 0
        || GetClientOfUserId(PigAdvanced_g_boomUserId[source]) != source
        || GetGameTime() - PigAdvanced_g_boomTime[source] > PigAdvanced_EXPLOSION_WINDOW
        || PigAdvanced_g_boomClearAnnounced[source][target])
        return;

    int controlled = PigAdvanced_g_controlVictim[target];
    if (controlled == 0 && GetGameTime() - PigAdvanced_g_controlReleaseTime[target] <= PigAdvanced_CONTROL_RELEASE_WINDOW)
        controlled = PigAdvanced_g_controlReleaseVictim[target];
    if (controlled == 0)
        return;

    PigAdvanced_g_boomClearAnnounced[source][target] = true;
    char victimName[MAX_NAME_LENGTH + 24];
    PigAdvanced_FormatInfectedName(target, victimName, sizeof(victimName));
    CPrintToChatAll("%t", "Boomer Clear", PigAdvanced_g_boomName[source], victimName);
}

void PigAdvanced_Event_InfectedHurt(Event event, const char[] name, bool dontBroadcast)
{
    if (!PigAdvanced_g_cvEnable.BoolValue || !PigAdvanced_g_cvWitch.BoolValue || event.GetInt("amount") <= 0)
        return;

    int witch = event.GetInt("entityid");
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    if (witch <= MaxClients || witch > PigAdvanced_MAX_EDICTS || !PigAdvanced_IsWitch(witch)
        || !PigAdvanced_IsTeamClient(attacker, PigAdvanced_TEAM_INFECTED))
        return;

    PigAdvanced_g_witchAttackers[witch][attacker] = GetClientUserId(attacker);
}

void PigAdvanced_Event_WitchKilled(Event event, const char[] name, bool dontBroadcast)
{
    if (!PigAdvanced_g_cvEnable.BoolValue || !PigAdvanced_g_cvWitch.BoolValue)
        return;

    int witch = event.GetInt("witchid");
    int killer = GetClientOfUserId(event.GetInt("userid"));
    if (witch <= MaxClients || witch > PigAdvanced_MAX_EDICTS || !PigAdvanced_IsTeamClient(killer, PigAdvanced_TEAM_INFECTED)
        || GetEntProp(killer, Prop_Send, "m_zombieClass") == 8)
        return;

    char killerName[MAX_NAME_LENGTH + 24];
    char assists[512];
    char assistName[MAX_NAME_LENGTH + 24];
    PigAdvanced_FormatInfectedName(killer, killerName, sizeof(killerName));
    assists[0] = '\0';
    for (int client = 1; client <= MaxClients; client++)
    {
        if (client == killer || PigAdvanced_g_witchAttackers[witch][client] == 0
            || GetClientOfUserId(PigAdvanced_g_witchAttackers[witch][client]) != client
            || !PigAdvanced_IsTeamClient(client, PigAdvanced_TEAM_INFECTED))
            continue;

        PigAdvanced_FormatInfectedName(client, assistName, sizeof(assistName));
        if (assists[0] != '\0')
            StrCat(assists, sizeof(assists), "、");
        StrCat(assists, sizeof(assists), assistName);
    }

    if (assists[0] == '\0')
        CPrintToChatAll("%t", "Witch Kill", killerName);
    else
        CPrintToChatAll("%t", "Witch Kill Assist", killerName, assists);

    for (int client = 1; client <= MaxClients; client++)
        PigAdvanced_g_witchAttackers[witch][client] = 0;
}

void PigAdvanced_Event_ControlStart(Event event, const char[] name, bool dontBroadcast)
{
    if (!PigAdvanced_g_cvEnable.BoolValue)
        return;

    int attacker = GetClientOfUserId(event.GetInt("userid"));
    int victim = GetClientOfUserId(event.GetInt("victim"));
    if (!PigAdvanced_IsTeamClient(attacker, PigAdvanced_TEAM_INFECTED) || !PigAdvanced_IsTeamClient(victim, PigAdvanced_TEAM_SURVIVOR))
        return;

    int newClass = GetEntProp(attacker, Prop_Send, "m_zombieClass");
    if (newClass != 1 && newClass != 3 && newClass != 5 && newClass != 6)
        return;

    int attackerId = GetClientUserId(attacker);
    if (PigAdvanced_g_victimController[victim] == attackerId)
        return; // charger_carry_start and charger_pummel_start are one control

    int previousVictim = GetClientOfUserId(PigAdvanced_g_controlVictim[attacker]);
    if (previousVictim > 0 && previousVictim != victim)
        PigAdvanced_ReleaseControl(attacker, previousVictim);

    int oldId = PigAdvanced_g_victimController[victim];
    int oldClass = 0;
    if (oldId == 0 && GetGameTime() - PigAdvanced_g_recentReleaseTime[victim] <= PigAdvanced_CONTROL_RELEASE_WINDOW)
    {
        oldId = PigAdvanced_g_recentController[victim];
        oldClass = PigAdvanced_g_recentClass[victim];
    }
    int old = GetClientOfUserId(oldId);
    if (PigAdvanced_g_cvSteal.BoolValue && old > 0 && old != attacker && PigAdvanced_IsTeamClient(old, PigAdvanced_TEAM_INFECTED))
    {
        char newName[MAX_NAME_LENGTH + 24];
        char oldName[MAX_NAME_LENGTH + 24];
        PigAdvanced_FormatInfectedName(attacker, newName, sizeof(newName));
        PigAdvanced_FormatInfectedName(old, oldName, sizeof(oldName), oldClass);
        CPrintToChatAll("%t", "Control Steal", newName, oldName, victim);
    }

    PigAdvanced_g_controlVictim[attacker] = GetClientUserId(victim);
    PigAdvanced_g_controlClass[attacker] = newClass;
    PigAdvanced_g_victimController[victim] = attackerId;
    PigAdvanced_g_recentController[victim] = 0;
}

void PigAdvanced_Event_ControlEnd(Event event, const char[] name, bool dontBroadcast)
{
    int victim = GetClientOfUserId(event.GetInt("victim"));
    if (victim <= 0)
        return;

    int old = GetClientOfUserId(PigAdvanced_g_victimController[victim]);
    if (old <= 0)
        return;

    int expectedClass = 0;
    if (StrEqual(name, "tongue_release")) expectedClass = 1;
    else if (StrEqual(name, "pounce_end")) expectedClass = 3;
    else if (StrEqual(name, "jockey_ride_end")) expectedClass = 5;
    else expectedClass = 6;

    if (PigAdvanced_g_controlClass[old] == expectedClass)
        PigAdvanced_ReleaseControl(old, victim);
}

void PigAdvanced_ReleaseControl(int attacker, int victim)
{
    if (attacker <= 0 || attacker > MaxClients)
        return;

    if (victim == 0)
        victim = GetClientOfUserId(PigAdvanced_g_controlVictim[attacker]);
    if (victim > 0 && victim <= MaxClients && PigAdvanced_g_victimController[victim] == GetClientUserId(attacker))
    {
        PigAdvanced_g_recentController[victim] = PigAdvanced_g_victimController[victim];
        PigAdvanced_g_recentClass[victim] = PigAdvanced_g_controlClass[attacker];
        PigAdvanced_g_recentReleaseTime[victim] = GetGameTime();
        PigAdvanced_g_victimController[victim] = 0;
    }
    PigAdvanced_g_controlReleaseVictim[attacker] = PigAdvanced_g_controlVictim[attacker];
    PigAdvanced_g_controlReleaseTime[attacker] = GetGameTime();
    PigAdvanced_g_controlVictim[attacker] = 0;
    PigAdvanced_g_controlClass[attacker] = 0;
}

void PigAdvanced_ClearBoomer(int client)
{
    if (client <= 0 || client > MaxClients)
        return;
    PigAdvanced_g_boomUserId[client] = 0;
    PigAdvanced_g_boomKillerUserId[client] = 0;
    PigAdvanced_g_boomTime[client] = 0.0;
    PigAdvanced_g_boomExploded[client] = false;
    PigAdvanced_g_alarmAnnounced[client] = false;
    for (int victim = 1; victim <= MaxClients; victim++)
    {
        PigAdvanced_g_bileTime[client][victim] = 0.0;
        PigAdvanced_g_bileAnnounced[client][victim] = false;
        PigAdvanced_g_boomClearAnnounced[client][victim] = false;
    }
}

bool PigAdvanced_IsTeamClient(int client, int team)
{
    return client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == team;
}

bool PigAdvanced_IsInfectedClass(int client, int zombieClass)
{
    return PigAdvanced_IsTeamClient(client, PigAdvanced_TEAM_INFECTED)
        && GetEntProp(client, Prop_Send, "m_zombieClass") == zombieClass;
}

bool PigAdvanced_IsWitch(int entity)
{
    if (!IsValidEntity(entity))
        return false;
    char classname[32];
    GetEntityClassname(entity, classname, sizeof(classname));
    return StrEqual(classname, "witch");
}

void PigAdvanced_FormatInfectedName(int client, char[] buffer, int maxlen, int fallbackClass = 0)
{
    int zombieClass = fallbackClass;
    if (zombieClass == 0)
        zombieClass = GetEntProp(client, Prop_Send, "m_zombieClass");

    char className[16];
    switch (zombieClass)
    {
        case 1: strcopy(className, sizeof(className), "Smoker");
        case 2: strcopy(className, sizeof(className), "Boomer");
        case 3: strcopy(className, sizeof(className), "Hunter");
        case 4: strcopy(className, sizeof(className), "Spitter");
        case 5: strcopy(className, sizeof(className), "Jockey");
        case 6: strcopy(className, sizeof(className), "Charger");
        case 8: strcopy(className, sizeof(className), "Tank");
        default: strcopy(className, sizeof(className), "SI");
    }
    if (IsFakeClient(client))
        FormatEx(buffer, maxlen, "AI(%s)", className);
    else
        FormatEx(buffer, maxlen, "%N(%s)", client, className);
}
