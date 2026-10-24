#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <multicolors>

#undef REQUIRE_PLUGIN
#include <readyup>
#include <left4dhooks>

#define PLUGIN_VERSION "1.0.0"

#define TEAM_SPECTATOR 1
#define TEAM_SURVIVOR 2
#define TEAM_INFECTED 3

#define ZC_TONGUE 1
#define ZC_HUNTER 3
#define ZC_JOCKEY 5
#define ZC_CHARGER 6
#define ZC_TANK 8

#define MAX_MUSIC_BOXES 128
#define MAX_MUSIC_BOX_NAME 128
#define CONTROL_SCAN_INTERVAL 0.10
#define TANK_DEATH_RESOLVE_DELAY 0.35
#define ROUND_END_FALLBACK_DELAY 0.50

enum MusicTrack
{
	Track_MVP = 0,
	Track_RoundWin,
	Track_RoundLose,
	Track_Count
};

enum MusicAudience
{
	Audience_All = 0,
	Audience_SurvivorSpectator,
	Audience_Infected
};

static const char g_sTrackKeys[Track_Count][] =
{
	"mvp",
	"round_win",
	"round_lose"
};

static const char g_sTrackSuffix[Track_Count][] =
{
	"MVP",
	"round_win",
	"round_lose"
};

public Plugin myinfo =
{
	name = "L4D2 Music Box",
	author = "Zonemod",
	description = "Per-map music box selection and round outcome music for L4D2 versus.",
	version = PLUGIN_VERSION,
	url = ""
};

ConVar g_hCvarEnable;
ConVar g_hCvarDuration;

char g_sMusicBoxName[MAX_MUSIC_BOXES][MAX_MUSIC_BOX_NAME];
char g_sMusicBoxSound[MAX_MUSIC_BOXES][Track_Count][PLATFORM_MAX_PATH];
int g_iMusicBoxCount;
int g_iSelectedMusicBox = -1;
bool g_bSelectedSoundReady[Track_Count];

Handle g_hControlTimer;
Handle g_hLiveTimer;
Handle g_hTankDeathTimer;
Handle g_hRoundEndFallback;
Handle g_hStopTimer[Track_Count];

char g_sActiveSound[Track_Count][PLATFORM_MAX_PATH];
int g_iActiveUserId[Track_Count][MAXPLAYERS + 1];

bool g_bLateLoad;
bool g_bMapPrepared;
char g_sPreparedMap[64];

int g_iRoundToken;
float g_fRoundStartTime;
bool g_bRoundLive;
bool g_bLiveAnnouncementSent;
bool g_bRoundEnding;
bool g_bRoundLost;
bool g_bMultiControlWipe;
float g_fMultiControlSince;
bool g_bEndVersusForwardSeen;
bool g_bTankSeen;
bool g_bTankDeathPending;
bool g_bTankKilled;
bool g_bTankKillHadFreeSurvivor;
bool g_bTankPerfect;
bool g_bTankEncounterCasualty;
bool g_bTankOutcomeResolved;
int g_iCurrentTankClient;
bool g_bKnownTank[MAXPLAYERS + 1];

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int errMax)
{
	g_bLateLoad = late;

	if (GetEngineVersion() != Engine_Left4Dead2)
	{
		strcopy(error, errMax, "L4D2 Music Box only supports Left 4 Dead 2.");
		return APLRes_SilentFailure;
	}

	RegPluginLibrary("l4d2_musicbox");
	return APLRes_Success;
}

public void OnPluginStart()
{
	g_hCvarEnable = CreateConVar(
		"l4d2_musicbox_enable", "1",
		"Enable the L4D2 music box plugin.",
		FCVAR_NOTIFY, true, 0.0, true, 1.0);

	// Keep this name compatible with the existing round-end audio setting.
	// 0.0 means the client plays the file until its natural end.
	g_hCvarDuration = CreateConVar(
		"l4d2_skill_advanced_round_end_sound_duration", "0.0",
		"Stop music box playback after this many seconds; 0.0 means natural end.",
		FCVAR_NOTIFY, true, 0.0);

	AutoExecConfig(true, "l4d2_musicbox");

	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	HookEventEx("scavenge_round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("map_transition", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("mission_lost", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("finale_win", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("finale_vehicle_leaving", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEventEx("player_left_start_area", Event_PlayerLeftStartArea, EventHookMode_PostNoCopy);

	HookEventEx("tank_spawn", Event_TankSpawn, EventHookMode_Post);
	HookEventEx("tank_killed", Event_TankKilled, EventHookMode_Post);
	HookEventEx("item_pickup", Event_ItemPickup, EventHookMode_Post);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
	HookEventEx("player_incapacitated_start", Event_SurvivorDowned, EventHookMode_Post);
	HookEventEx("player_incapacitated", Event_SurvivorDowned, EventHookMode_Post);
	HookEventEx("player_ledge_grab", Event_SurvivorDowned, EventHookMode_Post);
	HookEventEx("player_team", Event_PlayerTeam, EventHookMode_PostNoCopy);
	HookEventEx("player_spawn", Event_PlayerSpawn, EventHookMode_PostNoCopy);
	HookEventEx("player_bot_replace", Event_PlayerSpawn, EventHookMode_PostNoCopy);
	HookEventEx("bot_player_replace", Event_PlayerSpawn, EventHookMode_PostNoCopy);

	LoadMusicBoxConfig();
	StartControlTimer();

	if (g_bLateLoad)
	{
		PrepareMapSelection();
		ResetRoundState();
	}
}

public void OnConfigsExecuted()
{
	// A plugin loaded during an already-running map does not receive the normal
	// OnMapStart callback. Prepare its selected file set in that case.
	if (g_bLateLoad && !g_bMapPrepared)
	{
		PrepareMapSelection();
	}
}

public void OnMapStart()
{
	g_bMapPrepared = false;
	PrepareMapSelection();
	ResetRoundState();
	StartControlTimer();
}

public void OnMapEnd()
{
	// Do not call StopSound here. Map transitions already stop client audio and
	// a natural-end track must not be cut by a round/map event.
	g_bMapPrepared = false;
	g_sPreparedMap[0] = '\0';
	g_iSelectedMusicBox = -1;
	g_bRoundEnding = true;

	delete g_hControlTimer;
	g_hControlTimer = null;
	delete g_hLiveTimer;
	g_hLiveTimer = null;
	delete g_hTankDeathTimer;
	g_hTankDeathTimer = null;
	delete g_hRoundEndFallback;
	g_hRoundEndFallback = null;

	for (MusicTrack track = Track_MVP; track < Track_Count; track++)
	{
		delete g_hStopTimer[track];
		g_hStopTimer[track] = null;
		g_sActiveSound[track][0] = '\0';
		for (int client = 1; client <= MaxClients; client++)
		{
			g_iActiveUserId[track][client] = 0;
		}
	}
}

public void OnPluginEnd()
{
	delete g_hControlTimer;
	g_hControlTimer = null;
	delete g_hLiveTimer;
	g_hLiveTimer = null;
	delete g_hTankDeathTimer;
	g_hTankDeathTimer = null;
	delete g_hRoundEndFallback;
	g_hRoundEndFallback = null;

	StopAllActiveTracks();
}

public void OnRoundIsLive()
{
	AnnounceRoundLive();
}

public Action L4D2_OnEndVersusModeRound(bool countSurvivors)
{
	g_bEndVersusForwardSeen = true;
	delete g_hRoundEndFallback;
	g_hRoundEndFallback = null;

	if (countSurvivors)
	{
		HandleRoundSuccess();
	}
	else
	{
		HandleRoundLoss();
	}

	return Plugin_Continue;
}

void PrepareMapSelection()
{
	char mapName[sizeof(g_sPreparedMap)];
	GetCurrentMap(mapName, sizeof(mapName));
	if (mapName[0] == '\0')
	{
		return;
	}

	if (g_bMapPrepared && StrEqual(mapName, g_sPreparedMap, false))
	{
		return;
	}

	LoadMusicBoxConfig();
	SelectMusicBox();
	RegisterSelectedSounds();

	strcopy(g_sPreparedMap, sizeof(g_sPreparedMap), mapName);
	g_bMapPrepared = true;
}

void LoadMusicBoxConfig()
{
	g_iMusicBoxCount = 0;
	g_iSelectedMusicBox = -1;

	for (int box = 0; box < MAX_MUSIC_BOXES; box++)
	{
		g_sMusicBoxName[box][0] = '\0';
		for (MusicTrack track = Track_MVP; track < Track_Count; track++)
		{
			g_sMusicBoxSound[box][track][0] = '\0';
		}
	}

	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), "configs/l4d2_musicbox.cfg");

	KeyValues kv = new KeyValues("MusicBoxes");
	if (!kv.ImportFromFile(path))
	{
		LogError("[MusicBox] Unable to load config: %s", path);
		delete kv;
		return;
	}

	if (!kv.GotoFirstSubKey(false))
	{
		LogError("[MusicBox] Config contains no music box entries: %s", path);
		delete kv;
		return;
	}

	do
	{
		if (g_iMusicBoxCount >= MAX_MUSIC_BOXES)
		{
			LogError("[MusicBox] Too many entries; maximum is %d.", MAX_MUSIC_BOXES);
			break;
		}

		int box = g_iMusicBoxCount;
		char sectionName[MAX_MUSIC_BOX_NAME];
		kv.GetSectionName(sectionName, sizeof(sectionName));
		kv.GetString("name", g_sMusicBoxName[box], sizeof(g_sMusicBoxName[]), sectionName);
		TrimString(g_sMusicBoxName[box]);

		char baseRaw[PLATFORM_MAX_PATH];
		char base[PLATFORM_MAX_PATH];
		kv.GetString("base", baseRaw, sizeof(baseRaw), "");
		NormalizeSoundPath(baseRaw, base, sizeof(base));

		bool hasAllTracks = true;
		for (MusicTrack track = Track_MVP; track < Track_Count; track++)
		{
			char raw[PLATFORM_MAX_PATH];
			kv.GetString(g_sTrackKeys[track], raw, sizeof(raw), "");
			TrimString(raw);

			if (raw[0] == '\0' && base[0] != '\0')
			{
				FormatEx(raw, sizeof(raw), "%s_%s.mp3", base, g_sTrackSuffix[track]);
			}

			if (!NormalizeSoundPath(raw, g_sMusicBoxSound[box][track], sizeof(g_sMusicBoxSound[][])))
			{
				hasAllTracks = false;
				continue;
			}

			char downloadPath[PLATFORM_MAX_PATH];
			BuildDownloadPath(g_sMusicBoxSound[box][track], downloadPath, sizeof(downloadPath));
			if (!FileExists(downloadPath, true))
			{
				LogError("[MusicBox] Music box \"%s\" is missing: %s", sectionName, downloadPath);
				hasAllTracks = false;
			}
		}

		if (!hasAllTracks)
		{
			LogError("[MusicBox] Entry \"%s\" is incomplete; skipped.", sectionName);
			continue;
		}

		if (g_sMusicBoxName[box][0] == '\0')
		{
			strcopy(g_sMusicBoxName[box], sizeof(g_sMusicBoxName[]), sectionName);
		}

		g_iMusicBoxCount++;
	}
	while (kv.GotoNextKey(false));

	delete kv;
	LogMessage("[MusicBox] Loaded %d music box entr%s from %s.",
		g_iMusicBoxCount, g_iMusicBoxCount == 1 ? "y" : "ies", path);
}

void SelectMusicBox()
{
	for (MusicTrack track = Track_MVP; track < Track_Count; track++)
	{
		g_bSelectedSoundReady[track] = false;
	}

	if (g_iMusicBoxCount <= 0)
	{
		LogError("[MusicBox] No usable music box is configured.");
		return;
	}

	g_iSelectedMusicBox = GetRandomInt(0, g_iMusicBoxCount - 1);
	LogMessage("[MusicBox] Selected \"%s\" for this map.",
		g_sMusicBoxName[g_iSelectedMusicBox]);
}

void RegisterSelectedSounds()
{
	if (g_iSelectedMusicBox < 0 || g_iSelectedMusicBox >= g_iMusicBoxCount)
	{
		return;
	}

	for (MusicTrack track = Track_MVP; track < Track_Count; track++)
	{
		char playbackPath[PLATFORM_MAX_PATH];
		strcopy(playbackPath, sizeof(playbackPath), g_sMusicBoxSound[g_iSelectedMusicBox][track]);
		if (playbackPath[0] == '\0')
		{
			continue;
		}

		char downloadPath[PLATFORM_MAX_PATH];
		BuildDownloadPath(playbackPath, downloadPath, sizeof(downloadPath));

		if (!FileExists(downloadPath, true))
		{
			LogError("[MusicBox] Selected file is missing on the server: %s", downloadPath);
			continue;
		}

		// Download path intentionally includes sound/.
		AddFileToDownloadsTable(downloadPath);
		PrecacheGeneric(downloadPath, true);
		if (!PrecacheSound(playbackPath, true))
		{
			// ClientCommand("play") reads the downloaded file directly.
			LogMessage("[MusicBox] Sound was not added to soundprecache: %s", playbackPath);
		}
		g_bSelectedSoundReady[track] = true;
		LogMessage("[MusicBox] Registered %s: play=\"%s\", download=\"%s\"",
			g_sTrackKeys[track], playbackPath, downloadPath);
	}
}

bool NormalizeSoundPath(const char[] input, char[] output, int maxlen)
{
	char temp[PLATFORM_MAX_PATH];
	strcopy(temp, sizeof(temp), input);
	TrimString(temp);
	ReplaceString(temp, sizeof(temp), "\\", "/");

	while (StrContains(temp, "sound/", false) == 0)
	{
		char stripped[PLATFORM_MAX_PATH];
		strcopy(stripped, sizeof(stripped), temp[6]);
		strcopy(temp, sizeof(temp), stripped);
	}

	if (temp[0] == '\0' || temp[0] == '/' ||
		StrContains(temp, "..", false) != -1 ||
		StrContains(temp, "\"", false) != -1 ||
		StrContains(temp, ";", false) != -1)
	{
		output[0] = '\0';
		return false;
	}

	bool isCustomPath = StrContains(temp, "custom/", false) == 0;
	bool isMusicBoxPath = StrContains(temp, "musicbox/", false) == 0;
	if (!isCustomPath && !isMusicBoxPath)
	{
		LogError("[MusicBox] Sound path is outside sound/custom or sound/musicbox: %s", temp);
		output[0] = '\0';
		return false;
	}

	strcopy(output, maxlen, temp);
	return true;
}

void BuildDownloadPath(const char[] playbackPath, char[] downloadPath, int maxlen)
{
	FormatEx(downloadPath, maxlen, "sound/%s", playbackPath);
}

void ResetRoundState()
{
	g_iRoundToken++;
	g_fRoundStartTime = GetGameTime();
	g_bRoundLive = false;
	g_bLiveAnnouncementSent = false;
	g_bRoundEnding = false;
	g_bRoundLost = false;
	g_bMultiControlWipe = false;
	g_fMultiControlSince = -1.0;
	g_bEndVersusForwardSeen = false;
	g_bTankSeen = false;
	g_bTankDeathPending = false;
	g_bTankKilled = false;
	g_bTankKillHadFreeSurvivor = false;
	g_bTankPerfect = false;
	g_bTankEncounterCasualty = false;
	g_bTankOutcomeResolved = false;
	g_iCurrentTankClient = 0;

	for (int client = 1; client <= MaxClients; client++)
	{
		g_bKnownTank[client] = false;
	}

	delete g_hLiveTimer;
	g_hLiveTimer = CreateTimer(
		0.25,
		Timer_FallbackLive,
		g_iRoundToken,
		TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);

	delete g_hTankDeathTimer;
	g_hTankDeathTimer = null;
	delete g_hRoundEndFallback;
	g_hRoundEndFallback = null;
}

void AnnounceRoundLive()
{
	if (g_bLiveAnnouncementSent || g_bRoundEnding)
	{
		return;
	}

	g_bLiveAnnouncementSent = true;
	g_bRoundLive = true;
	// Do not delete this timer here. AnnounceRoundLive() can be entered from
	// Timer_FallbackLive() itself; deleting the currently executing timer makes
	// SourceMod report an invalid timer handle when the callback returns.
	g_hLiveTimer = null;

	if (!g_hCvarEnable.BoolValue)
	{
		return;
	}

	DetectCurrentTanks();

	if (g_iSelectedMusicBox < 0 || g_iSelectedMusicBox >= g_iMusicBoxCount)
	{
		CPrintToChatAll("{yellow}★ 回合开始！{default} 本局没有可用的音乐盒配置。");
		return;
	}

	CPrintToChatAll(
		"{yellow}★ 回合开始！{default} 本局音乐盒：{green}%s{default}",
		g_sMusicBoxName[g_iSelectedMusicBox]);
}

public Action Timer_FallbackLive(Handle timer, int token)
{
	if (g_hLiveTimer != timer)
	{
		return Plugin_Stop;
	}

	if (token != g_iRoundToken || g_bLiveAnnouncementSent || g_bRoundEnding)
	{
		g_hLiveTimer = null;
		return Plugin_Stop;
	}

	if (!g_hCvarEnable.BoolValue)
	{
		g_hLiveTimer = null;
		return Plugin_Stop;
	}

	float elapsed = GetGameTime() - g_fRoundStartTime;
	if (LibraryExists("readyup"))
	{
		// Give ReadyUP its round_start handler time to enter ready state.
		if (elapsed < 0.50 || IsInReady())
		{
			return Plugin_Continue;
		}
	}
	else
	{
		// Without ReadyUP, round_start does not mean anyone has left the
		// saferoom. The start-area event is the primary signal; this native
		// also handles a plugin loaded after the survivors already left.
		if (GetFeatureStatus(FeatureType_Native, "L4D_HasAnySurvivorLeftSafeArea") != FeatureStatus_Available ||
			!L4D_HasAnySurvivorLeftSafeArea())
		{
			return Plugin_Continue;
		}
	}

	// This callback is about to return Plugin_Stop. Clear the stored handle
	// before AnnounceRoundLive(), otherwise that function would delete the
	// timer which is currently executing and SourceMod would report an
	// invalid timer handle.
	g_hLiveTimer = null;
	AnnounceRoundLive();
	return Plugin_Stop;
}

public Action Timer_CheckMultiControl(Handle timer)
{
	RecordTankEncounterCasualties();
	TryTriggerMultiControlWipe();
	return Plugin_Continue;
}

void RecordTankEncounterCasualties()
{
	if (!g_bTankSeen || g_bTankOutcomeResolved || g_bRoundEnding)
	{
		return;
	}

	for (int survivor = 1; survivor <= MaxClients; survivor++)
	{
		if (IsSurvivor(survivor) &&
			(!IsPlayerAlive(survivor) || IsSurvivorIncapacitated(survivor)))
		{
			g_bTankEncounterCasualty = true;
		}
	}
}

bool TryTriggerMultiControlWipe(bool endingNow = false)
{
	if (!g_hCvarEnable.BoolValue || !g_bRoundLive || g_bRoundEnding ||
		g_bRoundLost || g_bMultiControlWipe)
	{
		g_fMultiControlSince = -1.0;
		return false;
	}
	if (g_bTankKilled && g_bTankKillHadFreeSurvivor &&
		!g_bTankOutcomeResolved)
	{
		// Finish the already-won tank encounter before considering a
		// separate multi-control wipe that happens after the kill.
		g_fMultiControlSince = -1.0;
		return false;
	}

	int aliveSurvivors = CountAliveSurvivors();
	if (aliveSurvivors < 2)
	{
		g_fMultiControlSince = -1.0;
		return false;
	}

	// An incapacitated survivor is not a multi-control wipe. Keep waiting for
	// a revive or a real death instead of treating a downed survivor as a
	// terminal control target in a tank round.
	if (HasIncapacitatedSurvivor())
	{
		g_fMultiControlSince = -1.0;
		return false;
	}

	int controlledSurvivors = CountControlledSurvivors();
	if (controlledSurvivors >= aliveSurvivors)
	{
		float now = GetGameTime();
		if (g_fMultiControlSince < 0.0)
		{
			g_fMultiControlSince = now;
		}
		// A momentary simultaneous pin is not yet a wipe. A real round-end
		// event can confirm it without waiting for another scan.
		if (!endingNow && now - g_fMultiControlSince < 0.15)
		{
			return false;
		}
		LogMessage("[MusicBox] outcome=multi_control alive=%d controlled=%d incapacitated=%d tank_seen=%d tank_outcome_resolved=%d",
			aliveSurvivors,
			controlledSurvivors,
			CountIncapacitatedSurvivors(),
			g_bTankSeen,
			g_bTankOutcomeResolved);
		TriggerMultiControlWipe();
		return true;
	}

	g_fMultiControlSince = -1.0;
	return false;
}

void TriggerMultiControlWipe()
{
	if (g_bRoundEnding || g_bRoundLost || g_bMultiControlWipe)
	{
		return;
	}

	// This is the terminal state for the round. Any later tank death event is
	// ignored, which prevents a second track after a wipe.
	g_bMultiControlWipe = true;
	g_bRoundLost = true;
	g_bRoundEnding = true;
	g_bRoundLive = false;
	g_bTankDeathPending = false;
	delete g_hTankDeathTimer;
	g_hTankDeathTimer = null;

	AnnounceAndPlay("多控灭团！", Track_MVP, Audience_All);
}

int CountControlledSurvivors()
{
	bool controlled[MAXPLAYERS + 1];
	int count = 0;
	for (int survivor = 1; survivor <= MaxClients; survivor++)
	{
		controlled[survivor] = false;
	}

	for (int infected = 1; infected <= MaxClients; infected++)
	{
		if (!IsAliveInfected(infected))
		{
			continue;
		}

		int victim = GetControlVictim(infected);
		if (victim > 0 && victim <= MaxClients && IsSurvivor(victim) &&
			IsPlayerAlive(victim) && !IsSurvivorIncapacitated(victim))
		{
			controlled[victim] = true;
		}
	}

	for (int survivor = 1; survivor <= MaxClients; survivor++)
	{
		if (controlled[survivor])
		{
			count++;
		}
	}

	return count;
}

int CountAliveSurvivors()
{
	int count = 0;
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsSurvivor(client) && IsPlayerAlive(client))
		{
			count++;
		}
	}
	return count;
}

int CountFreeUprightSurvivors()
{
	int count = 0;
	for (int survivor = 1; survivor <= MaxClients; survivor++)
	{
		if (!IsSurvivor(survivor) || !IsPlayerAlive(survivor) ||
			IsSurvivorIncapacitated(survivor) || IsSurvivorControlled(survivor))
		{
			continue;
		}
		count++;
	}
	return count;
}

bool IsSurvivorControlled(int survivor)
{
	for (int infected = 1; infected <= MaxClients; infected++)
	{
		if (IsAliveInfected(infected) && GetControlVictim(infected) == survivor)
		{
			return true;
		}
	}
	return false;
}

bool HasIncapacitatedSurvivor()
{
	return CountIncapacitatedSurvivors() > 0;
}

int CountIncapacitatedSurvivors()
{
	int count = 0;
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsSurvivor(client) && IsPlayerAlive(client) &&
			IsSurvivorIncapacitated(client))
		{
			count++;
		}
	}

	return count;
}

int GetControlVictim(int infected)
{
	int victim = -1;
	switch (GetZombieClass(infected))
	{
		case ZC_TONGUE:
		{
			victim = GetEntityPropEntSafe(infected, "m_tongueVictim");
		}
		case ZC_HUNTER:
		{
			victim = GetEntityPropEntSafe(infected, "m_pounceVictim");
		}
		case ZC_JOCKEY:
		{
			victim = GetEntityPropEntSafe(infected, "m_jockeyVictim");
		}
		case ZC_CHARGER:
		{
			victim = GetEntityPropEntSafe(infected, "m_carryVictim");
			if (!IsSurvivor(victim))
			{
				victim = GetEntityPropEntSafe(infected, "m_pummelVictim");
			}
		}
	}
	return victim;
}

void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	ResetRoundState();
}

void Event_PlayerLeftStartArea(Event event, const char[] name, bool dontBroadcast)
{
	// Fallback for servers without ReadyUP or when ReadyUP is disabled.
	if (g_bRoundEnding || (LibraryExists("readyup") && IsInReady()))
	{
		return;
	}

	AnnounceRoundLive();
}

void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	DetectCurrentTanks();
}

void Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	if (StrEqual(name, "mission_lost", false))
	{
		HandleRoundLoss();
		return;
	}

	if (StrEqual(name, "map_transition", false) ||
		StrEqual(name, "finale_win", false) ||
		StrEqual(name, "finale_vehicle_leaving", false))
	{
		HandleRoundSuccess();
		return;
	}

	if (StrEqual(name, "round_end", false))
	{
		delete g_hRoundEndFallback;
		g_hRoundEndFallback = CreateTimer(
			ROUND_END_FALLBACK_DELAY,
			Timer_RoundEndFallback,
			g_iRoundToken,
			TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_RoundEndFallback(Handle timer, int token)
{
	if (g_hRoundEndFallback != timer)
	{
		return Plugin_Stop;
	}

	g_hRoundEndFallback = null;
	if (token != g_iRoundToken || g_bEndVersusForwardSeen || g_bRoundEnding)
	{
		return Plugin_Stop;
	}

	// Left4DHooks is the authoritative path in versus. This fallback is for
	// modes or installations where its round-end forward is unavailable.
	if (CountFreeUprightSurvivors() > 0)
	{
		HandleRoundSuccess();
	}
	else
	{
		HandleRoundLoss();
	}

	return Plugin_Stop;
}

void HandleRoundLoss()
{
	if (g_bRoundEnding)
	{
		return;
	}

	if (g_bTankKilled && g_bTankKillHadFreeSurvivor &&
		g_bTankDeathPending && !g_bTankOutcomeResolved)
	{
		ResolveTankDeath(true);
	}
	if (TryTriggerMultiControlWipe(true))
	{
		return;
	}

	// The tank encounter has its own result. A later round loss must not
	// turn an already won encounter into a second, opposite result.
	if (g_bTankSeen && !g_bTankOutcomeResolved)
	{
		if (g_bTankDeathPending && !HasLivingTank())
		{
			ResolveTankDeath(true);
		}
		if (!g_bTankOutcomeResolved)
		{
			ResolveTankFailure();
		}
	}

	g_bRoundLost = true;
	g_bRoundEnding = true;
	g_bRoundLive = false;
	g_bTankDeathPending = false;
	delete g_hTankDeathTimer;
	g_hTankDeathTimer = null;
}

void HandleRoundSuccess()
{
	if (g_bRoundEnding || g_bRoundLost || g_bMultiControlWipe)
	{
		return;
	}

	if (g_bTankSeen && !g_bTankOutcomeResolved)
	{
		if (g_bTankDeathPending && !HasLivingTank())
		{
			ResolveTankDeath(true);
		}
		if (!g_bTankOutcomeResolved)
		{
			ResolveTankFailure();
		}
	}

	g_bRoundEnding = true;
	g_bRoundLive = false;
	g_bTankDeathPending = false;
	delete g_hTankDeathTimer;
	g_hTankDeathTimer = null;
}

void Event_TankSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	MarkTankSeen(client);
}

void Event_TankKilled(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	LogMessage("[MusicBox] event=tank_killed client=%d current_tank=%d tank_seen=%d",
		client,
		g_iCurrentTankClient,
		g_bTankSeen);
	if (!g_bTankSeen)
	{
		// No spawn signal means the encounter history is unknown, so it
		// cannot be classified as a perfect tank kill.
		g_bTankEncounterCasualty = true;
	}
	g_bTankSeen = true;
	if (client > 0)
	{
		g_bKnownTank[client] = false;
		if (g_iCurrentTankClient == client)
		{
			g_iCurrentTankClient = 0;
		}
	}
	ScheduleTankDeathResolution();
}

void Event_ItemPickup(Event event, const char[] name, bool dontBroadcast)
{
	char item[64];
	event.GetString("item", item, sizeof(item));
	if (!StrEqual(item, "tank_claw", false))
	{
		return;
	}

	int client = GetClientOfUserId(event.GetInt("userid"));
	MarkTankSeen(client);
}

void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("userid"));
	if (victim <= 0 || victim > MaxClients)
	{
		return;
	}

	if (IsSurvivor(victim) && g_bTankSeen &&
		!g_bTankOutcomeResolved)
	{
		g_bTankEncounterCasualty = true;
	}

	if (!IsLikelyTank(victim))
	{
		return;
	}

	g_bKnownTank[victim] = false;
	if (g_iCurrentTankClient == victim)
	{
		g_iCurrentTankClient = 0;
	}
	if (!g_bTankSeen)
	{
		g_bTankEncounterCasualty = true;
	}
	g_bTankSeen = true;
	ScheduleTankDeathResolution();
}

void Event_SurvivorDowned(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_bTankSeen || g_bTankOutcomeResolved || g_bRoundEnding)
	{
		return;
	}

	int survivor = GetClientOfUserId(event.GetInt("userid"));
	if (IsSurvivor(survivor))
	{
		g_bTankEncounterCasualty = true;
	}
}

void Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client <= 0)
	{
		return;
	}
	if (IsTankClient(client))
	{
		MarkTankSeen(client);
	}
	else
	{
		g_bKnownTank[client] = false;
		if (g_iCurrentTankClient == client)
		{
			g_iCurrentTankClient = 0;
		}
	}
}

public void OnClientDisconnect(int client)
{
	g_bKnownTank[client] = false;
	if (g_iCurrentTankClient == client)
	{
		g_iCurrentTankClient = 0;
	}
}

void MarkTankSeen(int client)
{
	if (client <= 0 || client > MaxClients || !IsClientInGame(client))
	{
		return;
	}

	if (g_iCurrentTankClient > 0 && g_iCurrentTankClient != client)
	{
		// A tank control pass changes the player holding the tank. Do not later
		// mistake a normal death of the old controller for the tank's death.
		g_bKnownTank[g_iCurrentTankClient] = false;
	}

	g_bTankSeen = true;
	g_bKnownTank[client] = true;
	g_iCurrentTankClient = client;
}

void DetectCurrentTanks()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsTankClient(client))
		{
			MarkTankSeen(client);
		}
	}
}

void ScheduleTankDeathResolution()
{
	if (!g_bTankSeen || g_bRoundEnding || g_bRoundLost || g_bMultiControlWipe ||
		g_bTankOutcomeResolved)
	{
		return;
	}

	if (!HasLivingTank())
	{
		CaptureTankKillState();
	}

	g_bTankDeathPending = true;
	delete g_hTankDeathTimer;
	g_hTankDeathTimer = CreateTimer(
		TANK_DEATH_RESOLVE_DELAY,
		Timer_ResolveTankDeath,
		g_iRoundToken,
		TIMER_FLAG_NO_MAPCHANGE);
}

void CaptureTankKillState()
{
	if (g_bTankKilled)
	{
		return;
	}

	g_bTankKilled = true;
	g_bTankKillHadFreeSurvivor = CountFreeUprightSurvivors() > 0;
}

public Action Timer_ResolveTankDeath(Handle timer, int token)
{
	if (g_hTankDeathTimer != timer)
	{
		return Plugin_Stop;
	}

	g_hTankDeathTimer = null;
	if (token != g_iRoundToken)
	{
		return Plugin_Stop;
	}

	ResolveTankDeath(false);
	return Plugin_Stop;
}

void ResolveTankDeath(bool force)
{
	if (g_bTankOutcomeResolved || g_bRoundLost || g_bMultiControlWipe || g_bRoundEnding)
	{
		return;
	}

	if (!force && !g_bTankDeathPending)
	{
		return;
	}

	if (HasLivingTank())
	{
		g_bTankDeathPending = false;
		return;
	}

	g_bTankDeathPending = false;
	CaptureTankKillState();
	RecordTankEncounterCasualties();
	if (CountIncapacitatedSurvivors() > 0)
	{
		g_bTankEncounterCasualty = true;
	}
	g_bTankPerfect = !g_bTankEncounterCasualty;
	if (!g_bTankKillHadFreeSurvivor && TryTriggerMultiControlWipe(true))
	{
		return;
	}

	LogMessage("[MusicBox] outcome=tank_killed free_at_kill=%d perfect=%d force=%d",
		g_bTankKillHadFreeSurvivor, g_bTankPerfect, force);
	if (!g_bTankKillHadFreeSurvivor)
	{
		ResolveTankFailure();
		return;
	}

	g_bTankOutcomeResolved = true;
	if (g_bTankPerfect)
	{
		AnnounceAndPlay("完美通过坦克局！", Track_MVP, Audience_SurvivorSpectator);
	}
	else
	{
		AnnounceAndPlay("通过坦克局！", Track_RoundWin, Audience_SurvivorSpectator);
	}

	PlayTrack(Track_RoundLose, Audience_Infected);
}

void ResolveTankFailure()
{
	if (g_bTankOutcomeResolved || g_bMultiControlWipe)
	{
		return;
	}

	g_bTankOutcomeResolved = true;
	LogMessage("[MusicBox] outcome=tank_encounter_failed tank_killed=%d free_at_kill=%d",
		g_bTankKilled, g_bTankKillHadFreeSurvivor);
	PlayTrack(Track_RoundWin, Audience_Infected);
	AnnounceAndPlay("未通过坦克局！", Track_RoundLose, Audience_SurvivorSpectator);
}

bool HasLivingTank()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsTankClient(client) && IsPlayerAlive(client))
		{
			return true;
		}
	}
	return false;
}

void AnnounceAndPlay(const char[] reason, MusicTrack track, MusicAudience audience)
{
	if (!g_hCvarEnable.BoolValue)
	{
		return;
	}
	if (g_iSelectedMusicBox < 0 || g_iSelectedMusicBox >= g_iMusicBoxCount ||
		!g_bSelectedSoundReady[track])
	{
		CPrintToChatAll("{yellow}☀ %s", reason);
		return;
	}

	CPrintToChatAll(
		"{yellow}★ %s{default} 音乐盒：{green}%s{default}",
		reason,
		g_sMusicBoxName[g_iSelectedMusicBox]);

	PlayTrack(track, audience);
}

void PlayTrack(MusicTrack track, MusicAudience audience)
{
	if (!g_hCvarEnable.BoolValue ||
		g_iSelectedMusicBox < 0 || g_iSelectedMusicBox >= g_iMusicBoxCount ||
		!g_bSelectedSoundReady[track])
	{
		return;
	}

	char soundPath[PLATFORM_MAX_PATH];
	strcopy(soundPath, sizeof(soundPath), g_sMusicBoxSound[g_iSelectedMusicBox][track]);
	if (soundPath[0] == '\0')
	{
		return;
	}

	// A configured timed playback is replaced by another play of this track.
	// Natural-end playback is left alone.
	if (g_hStopTimer[track] != null)
	{
		StopTrackForRecipients(track);
	}
	delete g_hStopTimer[track];
	g_hStopTimer[track] = null;
	strcopy(g_sActiveSound[track], sizeof(g_sActiveSound[]), soundPath);
	for (int client = 1; client <= MaxClients; client++)
	{
		g_iActiveUserId[track][client] = 0;
	}

	int sent = 0;
	for (int client = 1; client <= MaxClients; client++)
	{
		if (ShouldPlayToClient(client, audience))
		{
			// Playback path intentionally does not include sound/.
			ClientCommand(client, "play %s", soundPath);
			g_iActiveUserId[track][client] = GetClientUserId(client);
			sent++;
		}
	}

	float duration = g_hCvarDuration.FloatValue;
	if (duration > 0.0)
	{
		g_hStopTimer[track] = CreateTimer(
			duration,
			Timer_StopTrack,
			view_as<int>(track),
			TIMER_FLAG_NO_MAPCHANGE);
	}

	LogMessage("[MusicBox] Played %s (play=\"%s\") to audience=%d clients=%d duration=%.2f",
		g_sTrackKeys[track], soundPath, view_as<int>(audience), sent, duration);
}

bool ShouldPlayToClient(int client, MusicAudience audience)
{
	if (client <= 0 || client > MaxClients || !IsClientInGame(client) || IsFakeClient(client))
	{
		return false;
	}

	switch (audience)
	{
		case Audience_All:
		{
			return true;
		}
		case Audience_SurvivorSpectator:
		{
			int team = GetClientTeam(client);
			return team == TEAM_SURVIVOR || team == TEAM_SPECTATOR;
		}
		case Audience_Infected:
		{
			return GetClientTeam(client) == TEAM_INFECTED;
		}
	}

	return false;
}

public Action Timer_StopTrack(Handle timer, int track)
{
	if (track < 0 || track >= view_as<int>(Track_Count) || g_hStopTimer[track] != timer)
	{
		return Plugin_Stop;
	}

	g_hStopTimer[track] = null;
	if (g_sActiveSound[track][0] != '\0')
	{
		StopTrackForRecipients(view_as<MusicTrack>(track));
		g_sActiveSound[track][0] = '\0';
	}

	return Plugin_Stop;
}

void StopAllActiveTracks()
{
	for (MusicTrack track = Track_MVP; track < Track_Count; track++)
	{
		delete g_hStopTimer[track];
		g_hStopTimer[track] = null;
		if (g_sActiveSound[track][0] != '\0')
		{
			StopTrackForRecipients(track);
			g_sActiveSound[track][0] = '\0';
		}
	}
}

void StopTrackForRecipients(MusicTrack track)
{
	for (int slot = 1; slot <= MaxClients; slot++)
	{
		int userId = g_iActiveUserId[track][slot];
		if (userId <= 0)
		{
			continue;
		}
		int client = GetClientOfUserId(userId);
		if (client > 0 && IsClientInGame(client))
		{
			StopSound(client, SNDCHAN_AUTO, g_sActiveSound[track]);
		}
		g_iActiveUserId[track][slot] = 0;
	}
}

bool IsSurvivor(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) &&
		GetClientTeam(client) == TEAM_SURVIVOR;
}

bool IsAliveInfected(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) &&
		GetClientTeam(client) == TEAM_INFECTED && IsPlayerAlive(client);
}

bool IsTankClient(int client)
{
	return client > 0 && client <= MaxClients && IsClientInGame(client) &&
		GetClientTeam(client) == TEAM_INFECTED && GetZombieClass(client) == ZC_TANK;
}

bool IsLikelyTank(int client)
{
	return client == g_iCurrentTankClient || g_bKnownTank[client] || IsTankClient(client);
}

int GetZombieClass(int client)
{
	if (client <= 0 || client > MaxClients || !IsClientInGame(client) ||
		!HasEntProp(client, Prop_Send, "m_zombieClass"))
	{
		return 0;
	}
	return GetEntProp(client, Prop_Send, "m_zombieClass");
}

int GetEntityPropEntSafe(int entity, const char[] prop)
{
	if (entity <= 0 || !IsValidEntity(entity) || !HasEntProp(entity, Prop_Send, prop))
	{
		return -1;
	}
	return GetEntPropEnt(entity, Prop_Send, prop);
}

bool IsSurvivorIncapacitated(int client)
{
	if (!IsSurvivor(client))
	{
		return false;
	}
	return (HasEntProp(client, Prop_Send, "m_isIncapacitated") &&
		GetEntProp(client, Prop_Send, "m_isIncapacitated", 1) != 0) ||
		(HasEntProp(client, Prop_Send, "m_isHangingFromLedge") &&
		GetEntProp(client, Prop_Send, "m_isHangingFromLedge", 1) != 0) ||
		(HasEntProp(client, Prop_Send, "m_isFallingFromLedge") &&
		GetEntProp(client, Prop_Send, "m_isFallingFromLedge", 1) != 0);
}

void StartControlTimer()
{
	if (g_hControlTimer == null)
	{
		g_hControlTimer = CreateTimer(
			CONTROL_SCAN_INTERVAL,
			Timer_CheckMultiControl,
			_,
			TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	}
}
