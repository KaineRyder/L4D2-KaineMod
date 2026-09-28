#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <colors>

public Plugin myinfo =
{
	name = "L4D2 Network Monitor",
	author = "OpenAI",
	description = "Shows connected players' latency, packet loss, and choke.",
	version = "1.0.0",
	url = ""
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_network", Command_Network, "Shows network statistics for connected players.");
	RegConsoleCmd("sm_net", Command_Network, "Alias for sm_network.");
}

public Action Command_Network(int client, int args)
{
	if (client <= 0 || !IsClientInGame(client))
	{
		ReplyToCommand(client, "\x04[网络监测] 请在游戏内使用 !network 或 !net。");
		return Plugin_Handled;
	}

	CPrintToChat(client, "{orange}[网络监测]{default} {lightgreen}当前玩家网络状态：");

	int count;
	for (int target = 1; target <= MaxClients; target++)
	{
		if (!IsClientInGame(target) || IsFakeClient(target))
		{
			continue;
		}

		float ping = GetClientAvgLatency(target, NetFlow_Both);
		float lossUp = GetClientAvgLoss(target, NetFlow_Incoming);
		float lossDown = GetClientAvgLoss(target, NetFlow_Outgoing);
		float serverChoke = GetClientAvgChoke(target, NetFlow_Outgoing);
		char pingText[24], lossUpText[24], lossDownText[24], chokeText[24];

		if (ping < 0.0)
		{
			strcopy(pingText, sizeof(pingText), "N/A");
		}
		else
		{
			Format(pingText, sizeof(pingText), "%d ms", RoundToNearest(ping * 1000.0));
		}

		FormatPercent(lossUp, lossUpText, sizeof(lossUpText));
		FormatPercent(lossDown, lossDownText, sizeof(lossDownText));
		FormatPercent(serverChoke, chokeText, sizeof(chokeText));

		CPrintToChat(client,
			"{orange}[网络监测]{default} {lightgreen}%N | Ping: %s | Loss: 上行 %s / 下行 %s | 服务器Choke: %s",
			target,
			pingText,
			lossUpText,
			lossDownText,
			chokeText);
		count++;
	}

	if (count == 0)
	{
		CPrintToChat(client, "{orange}[网络监测]{default} {lightgreen}当前没有已连接的真人玩家。");
	}

	return Plugin_Handled;
}

void FormatPercent(float value, char[] buffer, int maxLength)
{
	if (value < 0.0)
	{
		strcopy(buffer, maxLength, "N/A");
		return;
	}

	Format(buffer, maxLength, "%.1f%%", value * 100.0);
}
