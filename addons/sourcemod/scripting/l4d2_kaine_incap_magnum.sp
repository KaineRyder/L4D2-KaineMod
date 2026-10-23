#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <dhooks>
#include <left4dhooks>

#define GAMEDATA_FILE "kaine_incap_magnum"
#define PISTOL_MAGNUM_WEAPON_ID 32
#define SPREAD_ATTRIBUTE_COUNT 6
#define MAX_FIREBULLET_NESTING 8

static const L4D2FloatWeaponAttributes g_eSpreadAttributes[SPREAD_ATTRIBUTE_COUNT] =
{
	L4D2FWA_SpreadPerShot,
	L4D2FWA_MaxSpread,
	L4D2FWA_MinDuckingSpread,
	L4D2FWA_MinStandingSpread,
	L4D2FWA_MinInAirSpread,
	L4D2FWA_MaxMovementSpread
};

DynamicHook g_hGetRateOfFire;
DynamicDetour g_hFireBullet;
int g_iRateOfFireHookOffset = -1;
int g_iSpreadHookDepth;
float g_fSavedSpread[MAX_FIREBULLET_NESTING][SPREAD_ATTRIBUTE_COUNT];
bool g_bSpreadApplied[MAX_FIREBULLET_NESTING];
int g_iOverflowDepth;

public Plugin myinfo =
{
	name = "Kaine incapacitated Magnum handling",
	author = "KaineMod",
	description = "Applies isolated spread and firing interval penalties to an incapacitated Magnum user",
	version = "1.0"
};

public void OnPluginStart()
{
	GameData rateData = new GameData("l4d2_pistol_delay");
	if (!rateData)
	{
		SetFailState("Missing gamedata l4d2_pistol_delay.txt");
	}

	g_iRateOfFireHookOffset = rateData.GetOffset("CTerrorGun::GetRateOfFire");
	delete rateData;
	if (g_iRateOfFireHookOffset == -1)
	{
		SetFailState("Missing CTerrorGun::GetRateOfFire offset");
	}

	g_hGetRateOfFire = new DynamicHook(g_iRateOfFireHookOffset, HookType_Entity, ReturnType_Float, ThisPointer_CBaseEntity);

	GameData fireData = new GameData(GAMEDATA_FILE);
	if (!fireData)
	{
		SetFailState("Missing gamedata " ... GAMEDATA_FILE ... ".txt");
	}

	g_hFireBullet = DynamicDetour.FromConf(fireData, "CTerrorPlayer::FireBullet");
	delete fireData;
	if (!g_hFireBullet)
	{
		SetFailState("Failed to configure CTerrorPlayer::FireBullet detour");
	}

	if (!g_hFireBullet.Enable(Hook_Pre, Detour_FireBullet_Pre)
		|| !g_hFireBullet.Enable(Hook_Post, Detour_FireBullet_Post))
	{
		SetFailState("Failed to enable CTerrorPlayer::FireBullet detour");
	}

	HookExistingMagnums();
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (StrEqual(classname, "weapon_pistol_magnum"))
	{
		RequestFrame(HookMagnumNextFrame, EntIndexToEntRef(entity));
	}
}

void HookExistingMagnums()
{
	int entity = -1;
	while ((entity = FindEntityByClassname(entity, "weapon_pistol_magnum")) != -1)
	{
		g_hGetRateOfFire.HookEntity(Hook_Post, entity, Hook_GetRateOfFire_Post);
	}
}

void HookMagnumNextFrame(any entityRef)
{
	int entity = EntRefToEntIndex(entityRef);
	if (entity > MaxClients && IsValidEntity(entity))
	{
		g_hGetRateOfFire.HookEntity(Hook_Post, entity, Hook_GetRateOfFire_Post);
	}
}

MRESReturn Hook_GetRateOfFire_Post(int weapon, DHookReturn hReturn)
{
	int owner = GetEntPropEnt(weapon, Prop_Send, "m_hOwner");
	if (!IsValidSurvivor(owner) || !IsIncapacitated(owner))
	{
		return MRES_Ignored;
	}

	// The engine already returns survivor_incapacitated_cycle_time for an
	// incapacitated owner. Scale that weapon-instance result without changing
	// the global Magnum CycleTime attribute.
	hReturn.Value = hReturn.Value * 1.2;
	return MRES_Supercede;
}

MRESReturn Detour_FireBullet_Pre(int client, DHookReturn hReturn, DHookParam hParams)
{
	if (g_iSpreadHookDepth >= MAX_FIREBULLET_NESTING)
	{
		g_iOverflowDepth++;
		return MRES_Ignored;
	}

	int stack = g_iSpreadHookDepth++;
	g_bSpreadApplied[stack] = IsValidSurvivor(client) && IsIncapacitated(client)
		&& DHookGetParam(hParams, 3) == PISTOL_MAGNUM_WEAPON_ID;
	if (!g_bSpreadApplied[stack])
	{
		return MRES_Ignored;
	}

	for (int i = 0; i < SPREAD_ATTRIBUTE_COUNT; i++)
	{
		g_fSavedSpread[stack][i] = L4D2_GetFloatWeaponAttribute("weapon_pistol_magnum", g_eSpreadAttributes[i]);
		L4D2_SetFloatWeaponAttribute("weapon_pistol_magnum", g_eSpreadAttributes[i], g_fSavedSpread[stack][i] * 1.25);
	}

	return MRES_Ignored;
}

MRESReturn Detour_FireBullet_Post(int client, DHookReturn hReturn, DHookParam hParams)
{
	if (g_iOverflowDepth > 0)
	{
		g_iOverflowDepth--;
		return MRES_Ignored;
	}

	if (g_iSpreadHookDepth <= 0)
	{
		return MRES_Ignored;
	}

	int stack = --g_iSpreadHookDepth;
	if (!g_bSpreadApplied[stack])
	{
		return MRES_Ignored;
	}
	g_bSpreadApplied[stack] = false;
	for (int i = 0; i < SPREAD_ATTRIBUTE_COUNT; i++)
	{
		L4D2_SetFloatWeaponAttribute("weapon_pistol_magnum", g_eSpreadAttributes[i], g_fSavedSpread[stack][i]);
	}

	return MRES_Ignored;
}

bool IsValidSurvivor(int client)
{
	return (client >= 1 && client <= MaxClients && IsClientInGame(client)
		&& GetClientTeam(client) == 2 && IsPlayerAlive(client));
}

bool IsIncapacitated(int client)
{
	return GetEntProp(client, Prop_Send, "m_isIncapacitated", 1) != 0;
}
