#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <multicolors>
#include <left4dhooks>

#define PLUGIN_NAME "l4d_pig_infected_notify_advanced"
#define PLUGIN_VERSION "1.0.0"
#define TEAM_SURVIVOR 2
#define TEAM_INFECTED 3
#define ZC_BOOMER 2
#define MAX_EDICTS 2048
#define EXPLOSION_WINDOW 0.6
#define ALARM_DISTANCE 350.0
#define CONTROL_RELEASE_WINDOW 0.25

public Plugin myinfo =
{
    name = "[L4D2] Pig Infected Notify Advanced",
    author = "Zonemod",
    description = "Reports Boomer accidents, Witch kills and infected control steals",
    version = PLUGIN_VERSION
};

ConVar g_cvEnable;
ConVar g_cvAlarm;
ConVar g_cvBoomClear;
ConVar g_cvWitch;
ConVar g_cvBile;
ConVar g_cvSteal;

int g_boomUserId[MAXPLAYERS + 1];
int g_boomKillerUserId[MAXPLAYERS + 1];
char g_boomName[MAXPLAYERS + 1][MAX_NAME_LENGTH];
float g_boomTime[MAXPLAYERS + 1];
float g_boomPos[MAXPLAYERS + 1][3];
bool g_boomExploded[MAXPLAYERS + 1];
float g_bileTime[MAXPLAYERS + 1][MAXPLAYERS + 1];
bool g_bileAnnounced[MAXPLAYERS + 1][MAXPLAYERS + 1];
bool g_alarmAnnounced[MAXPLAYERS + 1];
bool g_boomClearAnnounced[MAXPLAYERS + 1][MAXPLAYERS + 1];

int g_controlVictim[MAXPLAYERS + 1];       // survivor userid, indexed by infected client
int g_controlClass[MAXPLAYERS + 1];
int g_victimController[MAXPLAYERS + 1];   // infected userid, indexed by survivor client
int g_recentController[MAXPLAYERS + 1];
int g_recentClass[MAXPLAYERS + 1];
float g_recentReleaseTime[MAXPLAYERS + 1];
float g_controlReleaseTime[MAXPLAYERS + 1];
int g_controlReleaseVictim[MAXPLAYERS + 1];

int g_witchAttackers[MAX_EDICTS + 1][MAXPLAYERS + 1];

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int errorMax)
{
    if (GetEngineVersion() != Engine_Left4Dead2)
    {
        strcopy(error, errorMax, "This plugin requires Left 4 Dead 2.");
        return APLRes_SilentFailure;
    }
    return APLRes_Success;
}

public void OnPluginStart()
{
    LoadTranslations(PLUGIN_NAME ... ".phrases");
    g_cvEnable = CreateConVar(PLUGIN_NAME ... "_enable", "1", "Enable plugin", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    g_cvAlarm = CreateConVar(PLUGIN_NAME ... "_alarm", "1", "Report Boomer-triggered car alarms", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    g_cvBoomClear = CreateConVar(PLUGIN_NAME ... "_boom_clear", "1", "Report Boomer explosion clearing infected controls", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    g_cvWitch = CreateConVar(PLUGIN_NAME ... "_witch", "1", "Report infected Witch kills and assists", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    g_cvBile = CreateConVar(PLUGIN_NAME ... "_bile", "1", "Report teammates biled by shot Boomers", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    g_cvSteal = CreateConVar(PLUGIN_NAME ... "_steal", "1", "Report infected control steals", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    CreateConVar(PLUGIN_NAME ... "_version", PLUGIN_VERSION, "Plugin version", FCVAR_NOTIFY | FCVAR_DONTRECORD);
    AutoExecConfig(true, PLUGIN_NAME);

    HookEvent("round_start", Event_Reset, EventHookMode_PostNoCopy);
    HookEvent("round_end", Event_Reset, EventHookMode_PostNoCopy);
    HookEvent("player_spawn", Event_PlayerSpawn);
    HookEvent("player_death", Event_PlayerDeath);
    HookEvent("boomer_exploded", Event_BoomerExploded);
    HookEvent("player_now_it", Event_PlayerNowIt);
    HookEvent("infected_hurt", Event_InfectedHurt);
    HookEvent("witch_killed", Event_WitchKilled);

    HookEvent("tongue_grab", Event_ControlStart);
    HookEvent("lunge_pounce", Event_ControlStart);
    HookEvent("jockey_ride", Event_ControlStart);
    HookEvent("charger_carry_start", Event_ControlStart);
    HookEvent("charger_pummel_start", Event_ControlStart);
    HookEvent("tongue_release", Event_ControlEnd);
    HookEvent("pounce_end", Event_ControlEnd);
    HookEvent("jockey_ride_end", Event_ControlEnd);
    HookEvent("charger_carry_end", Event_ControlEnd);
    HookEvent("charger_pummel_end", Event_ControlEnd);

    // Covers a late plugin load while a round is already running.
    int entity = -1;
    while ((entity = FindEntityByClassname(entity, "prop_car_alarm")) != -1)
        HookSingleEntityOutput(entity, "OnCarAlarmStart", OnCarAlarmStart);
    while ((entity = FindEntityByClassname(entity, "prop_alarm_car")) != -1)
        HookSingleEntityOutput(entity, "OnCarAlarmStart", OnCarAlarmStart);
}

public void OnEntityCreated(int entity, const char[] classname)
{
    if (entity <= MaxClients || entity > MAX_EDICTS)
        return;

    if (StrEqual(classname, "witch"))
    {
        for (int client = 1; client <= MaxClients; client++)
            g_witchAttackers[entity][client] = 0;
    }
    else if (StrEqual(classname, "prop_car_alarm") || StrEqual(classname, "prop_alarm_car"))
    {
        HookSingleEntityOutput(entity, "OnCarAlarmStart", OnCarAlarmStart);
    }
}

public void OnClientDisconnect(int client)
{
    ClearBoomer(client);
    ReleaseControl(client, 0);
    for (int survivor = 1; survivor <= MaxClients; survivor++)
    {
        if (g_victimController[survivor] == GetClientUserId(client))
            g_victimController[survivor] = 0;
    }
    g_recentController[client] = 0;
    g_victimController[client] = 0;
}

void Event_Reset(Event event, const char[] name, bool dontBroadcast)
{
    for (int client = 1; client <= MaxClients; client++)
    {
        ClearBoomer(client);
        g_controlVictim[client] = 0;
        g_controlClass[client] = 0;
        g_victimController[client] = 0;
        g_recentController[client] = 0;
        g_recentReleaseTime[client] = 0.0;
        g_controlReleaseTime[client] = 0.0;
    }
    for (int entity = MaxClients + 1; entity <= MAX_EDICTS; entity++)
        for (int client = 1; client <= MaxClients; client++)
            g_witchAttackers[entity][client] = 0;
}

void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    if (client > 0)
    {
        ClearBoomer(client);
        ReleaseControl(client, 0);
    }
}

void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    int victim = GetClientOfUserId(event.GetInt("userid"));
    if (victim <= 0)
        return;

    // Keep the Boomer record until boomer_exploded and the related callbacks finish.
    if (IsInfectedClass(victim, ZC_BOOMER))
        RecordBoomer(victim, GetClientOfUserId(event.GetInt("attacker")));

    int controller = GetClientOfUserId(g_victimController[victim]);
    if (controller > 0)
        ReleaseControl(controller, victim);
    ReleaseControl(victim, 0);
    g_victimController[victim] = 0;
}

void RecordBoomer(int boomer, int killer)
{
    if (!IsInfectedClass(boomer, ZC_BOOMER))
        return;

    int userId = GetClientUserId(boomer);
    if (g_boomUserId[boomer] != userId || GetGameTime() - g_boomTime[boomer] > EXPLOSION_WINDOW)
    {
        for (int victim = 1; victim <= MaxClients; victim++)
        {
            g_bileAnnounced[boomer][victim] = false;
            g_boomClearAnnounced[boomer][victim] = false;
        }
        g_alarmAnnounced[boomer] = false;
        g_boomExploded[boomer] = false;
    }

    g_boomUserId[boomer] = userId;
    g_boomTime[boomer] = GetGameTime();
    GetClientAbsOrigin(boomer, g_boomPos[boomer]);
    GetClientName(boomer, g_boomName[boomer], sizeof(g_boomName[]));
    if (IsTeamClient(killer, TEAM_SURVIVOR))
        g_boomKillerUserId[boomer] = GetClientUserId(killer);
}

void Event_BoomerExploded(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_cvEnable.BoolValue)
        return;

    int boomer = GetClientOfUserId(event.GetInt("userid"));
    if (boomer <= 0)
        return;

    RecordBoomer(boomer, GetClientOfUserId(event.GetInt("attacker")));
    g_boomExploded[boomer] = true;
    CreateTimer(0.12, Timer_ReportBile, GetClientUserId(boomer), TIMER_FLAG_NO_MAPCHANGE);
}

void Event_PlayerNowIt(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_cvEnable.BoolValue || !g_cvBile.BoolValue || !event.GetBool("exploded") || !event.GetBool("by_boomer"))
        return;

    int victim = GetClientOfUserId(event.GetInt("userid"));
    int boomer = GetClientOfUserId(event.GetInt("attacker"));
    if (!IsTeamClient(victim, TEAM_SURVIVOR) || boomer <= 0 || !IsInfectedClass(boomer, ZC_BOOMER))
        return;

    g_bileTime[boomer][victim] = GetGameTime();
    ReportBile(boomer, victim);
}

Action Timer_ReportBile(Handle timer, int userId)
{
    int boomer = GetClientOfUserId(userId);
    if (boomer > 0)
        for (int victim = 1; victim <= MaxClients; victim++)
            ReportBile(boomer, victim);
    return Plugin_Stop;
}

void ReportBile(int boomer, int victim)
{
    if (!g_cvEnable.BoolValue || !g_cvBile.BoolValue || !IsTeamClient(victim, TEAM_SURVIVOR)
        || g_bileAnnounced[boomer][victim] || !g_boomExploded[boomer]
        || g_boomUserId[boomer] != GetClientUserId(boomer)
        || GetGameTime() - g_boomTime[boomer] > EXPLOSION_WINDOW
        || GetGameTime() - g_bileTime[boomer][victim] > EXPLOSION_WINDOW)
        return;

    int killer = GetClientOfUserId(g_boomKillerUserId[boomer]);
    if (!IsTeamClient(killer, TEAM_SURVIVOR) || killer == victim)
        return;

    g_bileAnnounced[boomer][victim] = true;
    CPrintToChatAll("%t", "Bile Teammate", killer, victim);
}

void OnCarAlarmStart(const char[] output, int caller, int activator, float delay)
{
    if (!g_cvEnable.BoolValue || !g_cvAlarm.BoolValue || !IsValidEntity(caller))
        return;

    // The output identifies the actual alarm car; triggered_car_alarm has no car ID.
    CreateTimer(0.12, Timer_ReportAlarm, EntIndexToEntRef(caller), TIMER_FLAG_NO_MAPCHANGE);
}

Action Timer_ReportAlarm(Handle timer, int carRef)
{
    int car = EntRefToEntIndex(carRef);
    if (!g_cvEnable.BoolValue || !g_cvAlarm.BoolValue || car == INVALID_ENT_REFERENCE)
        return Plugin_Stop;

    float carPos[3];
    GetEntPropVector(car, Prop_Send, "m_vecOrigin", carPos);
    int bestBoomer = 0;
    float bestDistance = ALARM_DISTANCE;
    for (int boomer = 1; boomer <= MaxClients; boomer++)
    {
        if (g_boomUserId[boomer] == 0 || !g_boomExploded[boomer] || g_alarmAnnounced[boomer]
            || GetClientOfUserId(g_boomUserId[boomer]) != boomer
            || GetGameTime() - g_boomTime[boomer] > EXPLOSION_WINDOW)
            continue;

        int killer = GetClientOfUserId(g_boomKillerUserId[boomer]);
        if (!IsTeamClient(killer, TEAM_SURVIVOR))
            continue;

        float distance = GetVectorDistance(carPos, g_boomPos[boomer]);
        if (distance < bestDistance)
        {
            bestDistance = distance;
            bestBoomer = boomer;
        }
    }

    if (bestBoomer > 0)
    {
        g_alarmAnnounced[bestBoomer] = true;
        int killer = GetClientOfUserId(g_boomKillerUserId[bestBoomer]);
        CPrintToChatAll("%t", "Boomer Alarm", killer, g_boomName[bestBoomer]);
    }
    return Plugin_Stop;
}

public void L4D2_OnStagger_Post(int target, int source)
{
    if (!g_cvEnable.BoolValue || !g_cvBoomClear.BoolValue || !IsTeamClient(target, TEAM_INFECTED)
        || source <= 0 || source > MaxClients || g_boomUserId[source] == 0
        || GetClientOfUserId(g_boomUserId[source]) != source
        || GetGameTime() - g_boomTime[source] > EXPLOSION_WINDOW
        || g_boomClearAnnounced[source][target])
        return;

    int controlled = g_controlVictim[target];
    if (controlled == 0 && GetGameTime() - g_controlReleaseTime[target] <= CONTROL_RELEASE_WINDOW)
        controlled = g_controlReleaseVictim[target];
    if (controlled == 0)
        return;

    g_boomClearAnnounced[source][target] = true;
    char victimName[MAX_NAME_LENGTH + 24];
    FormatInfectedName(target, victimName, sizeof(victimName));
    CPrintToChatAll("%t", "Boomer Clear", g_boomName[source], victimName);
}

void Event_InfectedHurt(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_cvEnable.BoolValue || !g_cvWitch.BoolValue || event.GetInt("amount") <= 0)
        return;

    int witch = event.GetInt("entityid");
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    if (witch <= MaxClients || witch > MAX_EDICTS || !IsWitch(witch)
        || !IsTeamClient(attacker, TEAM_INFECTED))
        return;

    g_witchAttackers[witch][attacker] = GetClientUserId(attacker);
}

void Event_WitchKilled(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_cvEnable.BoolValue || !g_cvWitch.BoolValue)
        return;

    int witch = event.GetInt("witchid");
    int killer = GetClientOfUserId(event.GetInt("userid"));
    if (witch <= MaxClients || witch > MAX_EDICTS || !IsTeamClient(killer, TEAM_INFECTED))
        return;

    char killerName[MAX_NAME_LENGTH + 24];
    char assists[512];
    char assistName[MAX_NAME_LENGTH + 24];
    FormatInfectedName(killer, killerName, sizeof(killerName));
    assists[0] = '\0';
    for (int client = 1; client <= MaxClients; client++)
    {
        if (client == killer || g_witchAttackers[witch][client] == 0
            || GetClientOfUserId(g_witchAttackers[witch][client]) != client
            || !IsTeamClient(client, TEAM_INFECTED))
            continue;

        FormatInfectedName(client, assistName, sizeof(assistName));
        if (assists[0] != '\0')
            StrCat(assists, sizeof(assists), "、");
        StrCat(assists, sizeof(assists), assistName);
    }

    if (assists[0] == '\0')
        CPrintToChatAll("%t", "Witch Kill", killerName);
    else
        CPrintToChatAll("%t", "Witch Kill Assist", killerName, assists);

    for (int client = 1; client <= MaxClients; client++)
        g_witchAttackers[witch][client] = 0;
}

void Event_ControlStart(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_cvEnable.BoolValue)
        return;

    int attacker = GetClientOfUserId(event.GetInt("userid"));
    int victim = GetClientOfUserId(event.GetInt("victim"));
    if (!IsTeamClient(attacker, TEAM_INFECTED) || !IsTeamClient(victim, TEAM_SURVIVOR))
        return;

    int newClass = GetEntProp(attacker, Prop_Send, "m_zombieClass");
    if (newClass != 1 && newClass != 3 && newClass != 5 && newClass != 6)
        return;

    int attackerId = GetClientUserId(attacker);
    if (g_victimController[victim] == attackerId)
        return; // charger_carry_start and charger_pummel_start are one control

    int previousVictim = GetClientOfUserId(g_controlVictim[attacker]);
    if (previousVictim > 0 && previousVictim != victim)
        ReleaseControl(attacker, previousVictim);

    int oldId = g_victimController[victim];
    int oldClass = 0;
    if (oldId == 0 && GetGameTime() - g_recentReleaseTime[victim] <= CONTROL_RELEASE_WINDOW)
    {
        oldId = g_recentController[victim];
        oldClass = g_recentClass[victim];
    }
    int old = GetClientOfUserId(oldId);
    if (g_cvSteal.BoolValue && old > 0 && old != attacker && IsTeamClient(old, TEAM_INFECTED))
    {
        char newName[MAX_NAME_LENGTH + 24];
        char oldName[MAX_NAME_LENGTH + 24];
        FormatInfectedName(attacker, newName, sizeof(newName));
        FormatInfectedName(old, oldName, sizeof(oldName), oldClass);
        CPrintToChatAll("%t", "Control Steal", newName, oldName, victim);
    }

    g_controlVictim[attacker] = GetClientUserId(victim);
    g_controlClass[attacker] = newClass;
    g_victimController[victim] = attackerId;
    g_recentController[victim] = 0;
}

void Event_ControlEnd(Event event, const char[] name, bool dontBroadcast)
{
    int victim = GetClientOfUserId(event.GetInt("victim"));
    if (victim <= 0)
        return;

    int old = GetClientOfUserId(g_victimController[victim]);
    if (old <= 0)
        return;

    int expectedClass = 0;
    if (StrEqual(name, "tongue_release")) expectedClass = 1;
    else if (StrEqual(name, "pounce_end")) expectedClass = 3;
    else if (StrEqual(name, "jockey_ride_end")) expectedClass = 5;
    else expectedClass = 6;

    if (g_controlClass[old] == expectedClass)
        ReleaseControl(old, victim);
}

void ReleaseControl(int attacker, int victim)
{
    if (attacker <= 0 || attacker > MaxClients)
        return;

    if (victim == 0)
        victim = GetClientOfUserId(g_controlVictim[attacker]);
    if (victim > 0 && victim <= MaxClients && g_victimController[victim] == GetClientUserId(attacker))
    {
        g_recentController[victim] = g_victimController[victim];
        g_recentClass[victim] = g_controlClass[attacker];
        g_recentReleaseTime[victim] = GetGameTime();
        g_victimController[victim] = 0;
    }
    g_controlReleaseVictim[attacker] = g_controlVictim[attacker];
    g_controlReleaseTime[attacker] = GetGameTime();
    g_controlVictim[attacker] = 0;
    g_controlClass[attacker] = 0;
}

void ClearBoomer(int client)
{
    if (client <= 0 || client > MaxClients)
        return;
    g_boomUserId[client] = 0;
    g_boomKillerUserId[client] = 0;
    g_boomTime[client] = 0.0;
    g_boomExploded[client] = false;
    g_alarmAnnounced[client] = false;
    for (int victim = 1; victim <= MaxClients; victim++)
    {
        g_bileTime[client][victim] = 0.0;
        g_bileAnnounced[client][victim] = false;
        g_boomClearAnnounced[client][victim] = false;
    }
}

bool IsTeamClient(int client, int team)
{
    return client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == team;
}

bool IsInfectedClass(int client, int zombieClass)
{
    return IsTeamClient(client, TEAM_INFECTED)
        && GetEntProp(client, Prop_Send, "m_zombieClass") == zombieClass;
}

bool IsWitch(int entity)
{
    if (!IsValidEntity(entity))
        return false;
    char classname[32];
    GetEntityClassname(entity, classname, sizeof(classname));
    return StrEqual(classname, "witch");
}

void FormatInfectedName(int client, char[] buffer, int maxlen, int fallbackClass = 0)
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
    Format(buffer, maxlen, "%N(%s)", client, className);
}
