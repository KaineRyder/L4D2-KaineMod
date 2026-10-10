#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <l4d2util>
#pragma semicolon 1

//	Colors || 笑胁械褌邪                                                                                                                                                 
// 	http://www.stm.dp.ua/web-design/color-html.php                                         
// 	{褑胁械褌,褑胁械褌,褑胁械褌,锌褉芯蟹褉邪褔薪芯褋褌褜} || {color,color,color,transparent} "0 - 255"              
//  Grenade Trails (Fredd) https://forums.alliedmods.net/showthread.php?p=594091

#define pipeColor      {255,48,48,255}  // Firebrick1
#define molotovColor   {255,255,0,255}  // Yellow
#define vomiteColor    {50,205,50,255}  // LimeGreen
#define grenadeColor   {160,32,240,255} // Purple
#define tankrockColor  {255,0,255,255}  // Magenta

new Sprite1;

float g_fwidth = 2.0;

new Handle:TrailsProjectileEnabled;

public Plugin:myinfo =
{
    name = "Trails_Projectile",
    author = "Fredd, Mister Game Over",
    description = "Trails Projectile",
    version = "1.0",
    url = "https://vk.com/club151027520"
}

public OnPluginStart()
{
	TrailsProjectileEnabled	=	CreateConVar("trails_enables",	"1",	"Enables/Disables plugin",	FCVAR_NOTIFY|FCVAR_PLUGIN);		
}
    
public OnMapStart()
{
    Sprite1 = PrecacheModel("materials/sprites/laserbeam.vmt");    
    //Sprite2 = PrecacheModel("materials/sprites/glow.vmt");  
}

// 懈褖械屑 写械泄褋褌胁懈械 泻芯褌芯褉芯械 薪邪屑 薪褍卸薪芯 || List Entities (Projectile)
// https://developer.valvesoftware.com/wiki/List_of_L4D2_Entities
// pipe bomb projectile         || 锌芯谢褢褌 斜芯屑斜褘
// molotov projectile           || 锌芯谢褢褌 屑芯谢芯褌芯胁邪
// grenade launcher projectile  || 锌芯谢褢褌 谐褉邪薪邪褌褘
// vomitjar projectile          || 锌芯谢褢褌 斜邪薪泻懈 褋 卸械谢褔褜褞 
// tank rock                    || 锌芯谢褢褌 泻邪屑薪褟
// Float:2.0 = Time Live Trail  || 胁褉械屑褟 卸懈蟹薪懈 褌褉械泄谢邪
		
public void OnEntityCreated(int entity, const char[] classname)
{
	if (!GetConVarBool(TrailsProjectileEnabled))
		return;

	if (IsTrailProjectile(classname))
		SDKHook(entity, SDKHook_SpawnPost, OnProjectileSpawned);
}

void OnProjectileSpawned(int entity)
{
	if (!IsValidEntity(entity) || !GetConVarBool(TrailsProjectileEnabled))
		return;

	char classname[64];
	GetEntityClassname(entity, classname, sizeof(classname));

	if (StrEqual(classname, "pipe_bomb_projectile"))
		SendProjectileTrail(entity, pipeColor);
	else if (StrEqual(classname, "molotov_projectile"))
		SendProjectileTrail(entity, molotovColor);
	else if (StrEqual(classname, "vomitjar_projectile"))
		SendProjectileTrail(entity, vomiteColor);
	else if (StrEqual(classname, "grenade_launcher_projectile"))
		SendProjectileTrail(entity, grenadeColor);
	else if (StrEqual(classname, "tank_rock"))
		SendProjectileTrail(entity, tankrockColor);
}

bool IsTrailProjectile(const char[] classname)
{
	return StrEqual(classname, "pipe_bomb_projectile")
		|| StrEqual(classname, "molotov_projectile")
		|| StrEqual(classname, "vomitjar_projectile")
		|| StrEqual(classname, "grenade_launcher_projectile")
		|| StrEqual(classname, "tank_rock");
}

void SendProjectileTrail(int entity, const int color[4])
{
	TE_SendToInf(entity, color);
}

void TE_SendToInf(int entity, const int color[4])
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && !IsFakeClient(i) && IsInfected(i))
		{
			// Each TE_SendToClient consumes the current TempEnt setup, so prepare
			// a fresh BeamFollow for every recipient.
			TE_SetupBeamFollow(entity, Sprite1, 0, 2.0, g_fwidth, g_fwidth, 5, color);
			TE_SendToClient(i);
		}
	}
}

