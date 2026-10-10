# Anne-Neri 与 Zonemod 的 SourceMod 插件清单

对比对象：`D:\CodingFile\Anne-Neri\addons\sourcemod\plugins` 与当前工作区 `addons\sourcemod\plugins`。按 `.smx` 文件名（忽略大小写）去重；同名插件视为共有。

统计：Anne-Neri 275 个不同名称，Zonemod 317 个不同名称；共有 105 个，Anne-Neri 独有 170 个，Zonemod 独有 212 个。目录中的重复副本只列一次。

说明口径：共有插件的源码在两边合并查找；能找到同名 `.sp` 时附源码链接。统计到 336 个名称至少有一份同名源码；能找到源码描述字段的 221 个。优先引用源码 `myinfo.description`；没有描述字段时按插件名保守归类，并在说明中标记。`.smx` 存在只说明文件在包内；`disabled` 子目录明确按停用标记处理，其他子目录是否加载需看服务器实际插件列表。

## 共有插件（105）

| 插件 | 用途 | `.smx` 位置 | 对应源码 |
|---|---|---|---|
| `1v1_skeetstats` | 源码描述：Shows 1v1-relevant info at end of round. | `optional\1v1_skeetstats.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/1v1_skeetstats.sp) |
| `admin-flatfile` | 源码描述：Reads admin files | `admin-flatfile.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/admin-flatfile.sp) |
| `adminhelp` | 源码描述：Display command information | `adminhelp.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/adminhelp.sp) |
| `adminmenu` | 源码描述：Administration Menu | `adminmenu.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/adminmenu.sp) |
| `admin-sql-prefetch` | 源码描述：Reads all admins from SQL | `disabled\admin-sql-prefetch.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/admin-sql-prefetch.sp) |
| `admin-sql-threaded` | 源码描述：Reads admins from SQL dynamically | `disabled\admin-sql-threaded.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/admin-sql-threaded.sp) |
| `antiflood` | 源码描述：Protects against chat flooding | `antiflood.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/antiflood.sp) |
| `attachments_api` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\attachments_api.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/attachments_api.sp) |
| `basebans` | 源码描述：Basic Banning Commands | `basebans.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/basebans.sp) |
| `basechat` | 源码描述：Basic Communication Commands | `basechat.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/basechat.sp) |
| `basecomm` | 源码描述：Provides methods of controlling communication. | `basecomm.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/basecomm.sp) |
| `basecommands` | 源码描述：Basic Admin Commands | `basecommands.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/basecommands.sp) |
| `basetriggers` | 源码描述：Adds ff, timeleft, thetime, and others. | `basetriggers.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/basetriggers.sp) |
| `basevotes` | 源码描述：Basic Vote Commands | `basevotes.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/basevotes.sp) |
| `bequiet` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `fixes\bequiet.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/bequiet.sp) |
| `boomer_horde_equalizer` | 源码描述：Fixes boomer hordes being different sizes based on wandering commons. | `optional\boomer_horde_equalizer.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/boomer_horde_equalizer.sp) |
| `clientprefs` | 源码描述：Client preferences and settings menu | `clientprefs.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/clientprefs.sp) |
| `code_patcher` | 源码描述：Code patcher | `optional\code_patcher.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/code_patcher.sp) |
| `command_buffer` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `fixes\command_buffer.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/command_buffer.sp) |
| `confoglcompmod` | 源码描述：A competitive mod for L4D2 | `confoglcompmod.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/confoglcompmod.sp) |
| `current` | 源码描述：Print survivor progress in flow percents  | `optional\current.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/current.sp) |
| `eq_finale_tanks` | 源码描述：Either two event tanks or one flow and one (second) event tank | `optional\eq_finale_tanks.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/eq_finale_tanks.sp) |
| `fix_fastmelee` | 源码描述：Fixes the bug with too fast melee attacks | `fixes\fix_fastmelee.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/fix_fastmelee.sp) |
| `funcommands` | 源码描述：Fun Commands | `funcommands.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/funcommands.sp) |
| `funvotes` | 源码描述：Fun Vote Commands | `funvotes.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/funvotes.sp) |
| `l4d_bash_kills` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d_bash_kills.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_bash_kills.sp) |
| `l4d_boss_percent` | 源码描述：Displays Boss Flows on Ready-Up and via command. Remade for NextMod. | `optional\l4d_boss_percent.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_boss_percent.sp) |
| `l4d_boss_vote` | 源码描述：Votin for boss change. | `optional\l4d_boss_vote.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_boss_vote.sp) |
| `l4d_common_ragdolls_be_gone` | 源码描述：Make ragdolls for common infected vanish into thin air server-side on death. | `optional\l4d_common_ragdolls_be_gone.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_common_ragdolls_be_gone.sp) |
| `l4d_console_spam` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `fixes\l4d_console_spam.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_console_spam.sp) |
| `l4d_no_cans` | 源码描述：Provides the ability to remove Gascans, Propane, Oxygen Tanks and Fireworks | `optional\l4d_no_cans.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_no_cans.sp) |
| `l4d_pause_message` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `l4d_pause_message.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_pause_message.sp) |
| `l4d_pounceprotect` | 源码描述：Prevent damage from blocking a hunter's ability to pounce | `optional\l4d_pounceprotect.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_pounceprotect.sp) |
| `l4d_rock_lagcomp` | 源码描述：Provides lag compensation for tank rock entities | `optional\l4d_rock_lagcomp.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_rock_lagcomp.sp) |
| `l4d_tank_control_eq` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d_tank_control_eq.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_tank_control_eq.sp) |
| `l4d_tank_damage_announce` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d_tank_damage_announce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_tank_damage_announce.sp) |
| `l4d_weapon_limits` | 源码描述：Restrict weapons individually or together | `optional\l4d_weapon_limits.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_weapon_limits.sp) |
| `l4d2_ai_damagefix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d2_ai_damagefix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_ai_damagefix.sp) |
| `l4d2_ellis_hunter_bandaid_fix` | 源码描述：Band-aid fix for Ellis' getup not matching the other Survivors | `fixes\l4d2_ellis_hunter_bandaid_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_ellis_hunter_bandaid_fix.sp) |
| `l4d2_horde_equaliser` | 源码描述：Make certain event hordes finite | `optional\l4d2_horde_equaliser.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_horde_equaliser.sp) |
| `l4d2_hunter_no_deadstops` | 源码描述：Prevents deadstops but allows m2s on standing hunters | `optional\l4d2_hunter_no_deadstops.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_hunter_no_deadstops.sp) |
| `l4d2_item_hint` | 源码描述：When using 'Look' in vocalize menu, print corresponding item to chat area and make item glow or create spot marker/infeced maker like back 4 blood. | `l4d2_item_hint.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_item_hint.sp) |
| `l4d2_jockey_hitbox_fix` | 源码描述：Fix jockey hitbox issues when riding survivors. | `fixes\l4d2_jockey_hitbox_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_jockey_hitbox_fix.sp) |
| `l4d2_jockey_skeet` | 源码描述：A dream come true | `optional\l4d2_jockey_skeet.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_jockey_skeet.sp) |
| `l4d2_jockeyed_ladder_fix` | 源码描述：Fixes jockeyed Survivors slowly sliding down the ladders | `fixes\l4d2_jockeyed_ladder_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_jockeyed_ladder_fix.sp) |
| `l4d2_ladder_rambos` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_ladder_rambos.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_ladder_rambos.sp) |
| `l4d2_map_vote` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\l4d2_map_vote.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_map_vote.sp) |
| `l4d2_melee_shenanigans` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_melee_shenanigans.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_melee_shenanigans.sp) |
| `l4d2_melee_spawn_control` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_melee_spawn_control.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_melee_spawn_control.sp) |
| `l4d2_nativevote` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `l4d2_nativevote.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_nativevote.sp) |
| `l4d2_no_hunter_deadstops` | 源码描述：Self-descriptive | `optional\l4d2_no_hunter_deadstops.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_no_hunter_deadstops.sp) |
| `l4d2_pickup` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_pickup.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_pickup.sp) |
| `l4d2_reload_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_reload_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_reload_fix.sp) |
| `l4d2_saferoom_detect` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_saferoom_detect.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_saferoom_detect.sp) |
| `l4d2_saferoom_item_remove` | 源码描述：Removes any saferoom item (start or end). | `optional\l4d2_saferoom_item_remove.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_saferoom_item_remove.sp) |
| `l4d2_script_cmd_swap` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `fixes\l4d2_script_cmd_swap.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_script_cmd_swap.sp) |
| `l4d2_sg552_zoom_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d2_sg552_zoom_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_sg552_zoom_fix.sp) |
| `l4d2_si_ffblock` | 源码描述：Disables friendly fire between infected players. | `optional\l4d2_si_ffblock.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_si_ffblock.sp) |
| `l4d2_si_staggers` | 源码描述：Removes SI staggers caused by other SI(Boomer, Charger, Witch) | `optional\l4d2_si_staggers.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_si_staggers.sp) |
| `l4d2_skill_detect` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `l4d2_skill_detect.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_skill_detect.sp) |
| `l4d2_slowdown_control` | 源码描述：Manages the water/gunfire slowdown for both teams | `optional\l4d2_slowdown_control.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_slowdown_control.sp) |
| `l4d2_smoker_drag_damage_interval` | 源码描述：Implements a native-like cvar and functionality that should've been there out of the box | `optional\l4d2_smoker_drag_damage_interval.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_smoker_drag_damage_interval.sp) |
| `l4d2_sound_manipulation` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\l4d2_sound_manipulation.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_sound_manipulation.sp) |
| `l4d2_source_keyvalues` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `l4d2_source_keyvalues.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_source_keyvalues.sp) |
| `l4d2_spectating_cheat` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_spectating_cheat.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_spectating_cheat.sp) |
| `l4d2_spit_spread_patch` | 源码描述：Fix various spit spread issues. | `fixes\l4d2_spit_spread_patch.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_spit_spread_patch.sp) |
| `l4d2_spitblock` | 源码描述：Blocks spit damage on various maps | `optional\l4d2_spitblock.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_spitblock.sp) |
| `l4d2_static_shotgun_spread` | 源码描述：Changes the values in the sgspread patch | `optional\l4d2_static_shotgun_spread.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_static_shotgun_spread.sp) |
| `l4d2_stats` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\l4d2_stats.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_stats.sp) |
| `l4d2_tank_attack_control` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_tank_attack_control.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_attack_control.sp) |
| `l4d2_tank_charger_m2_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_tank_charger_m2_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_charger_m2_fix.sp) |
| `l4d2_tank_damage_cvars` | 源码描述：Toggle Tank attack damage per type | `optional\l4d2_tank_damage_cvars.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_damage_cvars.sp) |
| `l4d2_tank_horde_monitor` | 源码描述：Monitors and changes state of infinite hordes during tanks | `optional\l4d2_tank_horde_monitor.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_horde_monitor.sp) |
| `l4d2_uniform_spit` | 源码描述：Make the spit deal a set amount of DPS under all circumstances | `optional\l4d2_uniform_spit.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_uniform_spit.sp) |
| `l4d2_unsilent_jockey` | 源码描述：Makes jockeys emit sound constantly. | `optional\l4d2_unsilent_jockey.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_unsilent_jockey.sp) |
| `l4d2_weapon_attributes` | 源码描述：Allowing tweaking of the attributes of all weapons | `optional\l4d2_weapon_attributes.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_weapon_attributes.sp) |
| `l4d2lib` | 源码描述：Useful natives and fowards for L4D2 Plugins | `optional\l4d2lib.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2lib.sp) |
| `l4dffannounce` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\l4dffannounce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4dffannounce.sp) |
| `l4dhots` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4dhots.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4dhots.sp) |
| `left4dhooks` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `left4dhooks.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/left4dhooks.sp) |
| `lerpmonitor` | 源码描述：Keep track of players' lerp settings | `optional\lerpmonitor.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/lerpmonitor.sp) |
| `mapchooser` | 源码描述：Automated Map Voting | `disabled\mapchooser.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/mapchooser.sp) |
| `match_vote` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `match_vote.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/match_vote.sp) |
| `MeleeInTheSafeRoom` | 源码描述：Spawns a selection of melee weapons in the saferoom, at the start of each round. | `optional\MeleeInTheSafeRoom.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/MeleeInTheSafeRoom.sp) |
| `nextmap` | 源码描述：Provides nextmap and sm_nextmap | `nextmap.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/nextmap.sp) |
| `nominations` | 源码描述：Provides Map Nominations | `disabled\nominations.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/nominations.sp) |
| `nosaferoomkits` | 源码描述：Removes Safe Room Medkits | `optional\nosaferoomkits.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/nosaferoomkits.sp) |
| `noteam_nudging` | 源码描述：Prevents small push effect between survior players, bots still get pushed. | `optional\noteam_nudging.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/noteam_nudging.sp) |
| `pill_passer` | 源码描述：Lets players pass pills and adrenaline with +reload when they are holding one of those items | `optional\pill_passer.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/pill_passer.sp) |
| `playercommands` | 源码描述：Misc. Player Commands | `playercommands.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/playercommands.sp) |
| `randomcycle` | 源码描述：Randomly chooses the next map. | `disabled\randomcycle.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/randomcycle.sp) |
| `readyup` | 源码描述：New and improved ready-up plugin with optimal for convenience. | `optional\readyup.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/readyup.sp) |
| `reservedslots` | 源码描述：Provides basic reserved slots | `reservedslots.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/reservedslots.sp) |
| `rockthevote` | 源码描述：Provides RTV Map Voting | `disabled\rockthevote.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/rockthevote.sp) |
| `rygive` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\rygive.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/rygive.sp) |
| `slots_vote` | 源码描述：Slots Voter | `optional\slots_vote.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/slots_vote.sp) |
| `smart_ai_rock` | 源码描述：Prevents AI tanks from throwing underhand rocks since he can't aim them correctly | `optional\smart_ai_rock.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/smart_ai_rock.sp) |
| `sounds` | 源码描述：Sound Commands | `sounds.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/sounds.sp) |
| `spechud` | 源码描述：Provides different HUDs for spectators | `optional\spechud.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/spechud.sp) |
| `specrates` | 源码描述：Forces low rates on spectators | `optional\specrates.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/specrates.sp) |
| `sql-admin-manager` | 源码描述：Manages SQL admins | `disabled\sql-admin-manager.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/sql-admin-manager.sp) |
| `starting_items` | 源码描述：Gives health items and throwables to survivors at the start of each round | `optional\starting_items.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/starting_items.sp) |
| `survivor_mvp` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\survivor_mvp.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/survivor_mvp.sp) |
| `TickrateFixes` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\TickrateFixes.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/TickrateFixes.sp) |
| `witch_and_tankifier` | 源码描述：Sets a tank spawn and has the option to remove the witch spawn point on every map | `optional\witch_and_tankifier.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/witch_and_tankifier.sp) |

## 仅 Anne-Neri 有（170）

| 插件 | 用途 | `.smx` 位置 | 对应源码 |
|---|---|---|---|
| `1v1_getup_skipped` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\1v1_getup_skipped.smx` | 无同名 `.sp`；编译文件可用 |
| `1v1_getup_skipped_charger` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\1v1_getup_skipped_charger.smx` | 无同名 `.sp`；编译文件可用 |
| `advertisements` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `optional\advertisements.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_boomer` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_boomer.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/ai_boomer.sp) |
| `ai_boomer_old` | 源码描述：Improves the AI behaviour of special infected | `optional\ai_boomer_old.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/ai_boomer_old.sp) |
| `ai_charger` | 源码描述：Ai Charger 2.0 | `optional\ai_charger.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/ai_charger.sp) |
| `ai_charger_boomer` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_charger_boomer.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_charger_old` | 源码描述：Improves the AI behaviour of special infected | `optional\ai_charger_old.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/ai_charger_old.sp) |
| `ai_charger3` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_charger3.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_hunter` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_hunter.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/ai_hunter.sp) |
| `ai_hunter_old` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_hunter_old.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_jockey` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_jockey.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/ai_jockey.sp) |
| `ai_jockey_old` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_jockey_old.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_smoker` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_smoker.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_smoker1` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_smoker1.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_smoker3` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_smoker3.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/ai_smoker3.sp) |
| `ai_spitter` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_spitter.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_tank` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_tank.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_tank_coop` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_tank_coop.smx` | 无同名 `.sp`；编译文件可用 |
| `ai_tank_old` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\ai_tank_old.smx` | 无同名 `.sp`；编译文件可用 |
| `all` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\all.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/all.sp) |
| `all4dead2` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `all4dead2.smx` | 无同名 `.sp`；编译文件可用 |
| `Allcharger` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\Allcharger.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/Allcharger.sp) |
| `Alone` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\Alone.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/Alone.sp) |
| `Alone_sea` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\Alone_sea.smx` | 无同名 `.sp`；编译文件可用 |
| `asiai` | 源码描述：Advanced Special Infected AI | `optional\asiai.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/asiai.sp) |
| `autoupdate` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\autoupdate.smx` | 无同名 `.sp`；编译文件可用 |
| `Charger_Collision_patch` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\Charger_Collision_patch.smx` | 无同名 `.sp`；编译文件可用 |
| `chargers` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\chargers.smx` | 无同名 `.sp`；编译文件可用 |
| `chatlog` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `extend\chatlog.smx` | 无同名 `.sp`；编译文件可用 |
| `clip_removal` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\clip_removal.smx` | 无同名 `.sp`；编译文件可用 |
| `common_blocker` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\common_blocker.smx` | 无同名 `.sp`；编译文件可用 |
| `confogl_autoloader` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `confogl_autoloader.smx` | 无同名 `.sp`；编译文件可用 |
| `confoglcompmod_realism` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `confoglcompmod_realism.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/confoglcompmod_realism.sp) |
| `Defib_Fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\Defib_Fix.smx` | 无同名 `.sp`；编译文件可用 |
| `familyshare_manager` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `familyshare_manager.smx` | 无同名 `.sp`；编译文件可用 |
| `finale_tank_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\finale_tank_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `FinaleFinishGodmode` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\FinaleFinishGodmode.smx` | 无同名 `.sp`；编译文件可用 |
| `FollowTarget_Detour` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\FollowTarget_Detour.smx` | 无同名 `.sp`；编译文件可用 |
| `fornite_l4d` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\fornite_l4d.smx` | 无同名 `.sp`；编译文件可用 |
| `gamedescription` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\gamedescription.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/gamedescription.sp) |
| `gnome` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\gnome.smx` | 无同名 `.sp`；编译文件可用 |
| `HitStatistics` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `extend\HitStatistics.smx` | 无同名 `.sp`；编译文件可用 |
| `hp_tank_show` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `extend\hp_tank_show.smx` | 无同名 `.sp`；编译文件可用 |
| `hunter_floor` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\hunter_floor.smx` | 无同名 `.sp`；编译文件可用 |
| `hunters` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\hunters.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/hunters.sp) |
| `infected_control_1128` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\infected_control_1128.smx` | 无同名 `.sp`；编译文件可用 |
| `infected_control_1128_old` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\infected_control_1128_old.smx` | 无同名 `.sp`；编译文件可用 |
| `infected_control_77` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\infected_control_77.smx` | 无同名 `.sp`；编译文件可用 |
| `infected_control_auto` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\infected_control_auto.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/infected_control_auto.sp) |
| `infected_control_tree` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\infected_control_tree.smx` | 无同名 `.sp`；编译文件可用 |
| `infected_teleport` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\infected_teleport.smx` | 无同名 `.sp`；编译文件可用 |
| `IsReachable_Detour` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\IsReachable_Detour.smx` | 无同名 `.sp`；编译文件可用 |
| `Jockeys` | 修改特感 AI、刷新/传送或相关玩法；具体行为依版本而异（按源码文件名判断）。 | `optional\Jockeys.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/Jockeys.sp) |
| `jointeam` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\jointeam.smx` | 无同名 `.sp`；编译文件可用 |
| `kill_tank` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\kill_tank.smx` | 无同名 `.sp`；编译文件可用 |
| `killsound` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\killsound.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/killsound.sp) |
| `l4d_air_abilities_patch` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d_air_abilities_patch.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d_air_abilities_patch.sp) |
| `l4d_fix_smokerbot_float` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d_fix_smokerbot_float.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_gear_transfer` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `extend\l4d_gear_transfer.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_hats` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `extend\l4d_hats.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_infected_movement` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d_infected_movement.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_infected_movement_bt` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d_infected_movement_bt.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_info_editor` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `l4d_info_editor.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_kick_si_bot_on_death` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d_kick_si_bot_on_death.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_multi_witches` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d_multi_witches.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_random_beam_item` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `extend\l4d_random_beam_item.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_reload_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d_reload_fix.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d_reload_fix.sp) |
| `l4d_stats` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `extend\l4d_stats.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_sweep_fist_patch` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d_sweep_fist_patch.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_tank_damage_announce_realism` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d_tank_damage_announce_realism.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_target_override` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d_target_override.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_use_priority` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\l4d_use_priority.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_versus_rescue_door_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d_versus_rescue_door_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_abbw_votemap` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\l4d2_abbw_votemap.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_antimelee` | 源码描述：Nerfes melee damage against tanks by a set amount of % | `optional\l4d2_antimelee.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_antimelee.sp) |
| `l4d2_asiai` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_asiai.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_callvote` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `extend\l4d2_callvote.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_character_manager` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\l4d2_character_manager.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_crouch_ff` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_crouch_ff.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_crouch_ff.sp) |
| `l4d2_doorlock` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\l4d2_doorlock.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_fast_melee_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_fast_melee_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_full_auto_weapon` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_full_auto_weapon.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_getitem` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_getitem.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_getupfix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_getupfix.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_godframes_control` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_godframes_control.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_GrenadeLauncher_AmmoPile_patch` | 源码描述：Allows GrenadeLauncher to use ammo piles | `optional\l4d2_GrenadeLauncher_AmmoPile_patch.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_GrenadeLauncher_AmmoPile_patch.sp) |
| `l4d2_health_return` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_health_return.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_horde_equaliser_test` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_horde_equaliser_test.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_incap_magnum` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_incap_magnum.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_infected_hp` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_infected_hp.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_jockeyed_charger_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_jockeyed_charger_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_LMC_Black_and_White_Notifier` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\l4d2_LMC_Black_and_White_Notifier.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_LMCCore` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_LMCCore.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_lookatweapon` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_lookatweapon.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_M60_nodrop_ammopile_patch` | 源码描述：Prevents m60 from dropping and allows use of ammo piles | `optional\l4d2_M60_nodrop_ammopile_patch.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_M60_nodrop_ammopile_patch.sp) |
| `l4d2_mapchanger` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\l4d2_mapchanger.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_melee_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_melee_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_MeleeInTheSafeRoom` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_MeleeInTheSafeRoom.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_menu` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `optional\l4d2_menu.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_multislots` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\l4d2_multislots.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_multislots.sp) |
| `l4d2_saferoom_gun_control` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_saferoom_gun_control.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_scripted_hud` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `extend\l4d2_scripted_hud.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/l4d2_scripted_hud.sp) |
| `l4d2_shotgun_ff` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_shotgun_ff.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_shove_infected_fly` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_shove_infected_fly.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_si_ladder_booster` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_si_ladder_booster.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_si_push` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_si_push.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_survivor_super_reload` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_survivor_super_reload.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_survivors_health` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_survivors_health.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_tank_color` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_tank_color.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_tank_throw` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_tank_throw.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_tankrun` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_tankrun.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_zs` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_zs.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2util` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2util.smx` | 无同名 `.sp`；编译文件可用 |
| `l4dafkfix_deadbot` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\l4dafkfix_deadbot.smx` | 无同名 `.sp`；编译文件可用 |
| `l4dinfectedbots` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4dinfectedbots.smx` | 无同名 `.sp`；编译文件可用 |
| `lilac` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\lilac.smx` | 无同名 `.sp`；编译文件可用 |
| `linux_auto_restart` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `linux_auto_restart.smx` | 无同名 `.sp`；编译文件可用 |
| `match_vote2` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\match_vote2.smx` | 无同名 `.sp`；编译文件可用 |
| `mixed_doubles` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\mixed_doubles.smx` | 无同名 `.sp`；编译文件可用 |
| `props` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `props.smx` | 无同名 `.sp`；编译文件可用 |
| `punch_angle` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\punch_angle.smx` | 无同名 `.sp`；编译文件可用 |
| `remove` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\remove.smx` | 无同名 `.sp`；编译文件可用 |
| `replace` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\replace.smx` | 无同名 `.sp`；编译文件可用 |
| `rpg` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\rpg.smx` | 无同名 `.sp`；编译文件可用 |
| `rpg_new` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\rpg_new.smx` | 无同名 `.sp`；编译文件可用 |
| `sam_vs` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\sam_vs.smx` | 无同名 `.sp`；编译文件可用 |
| `savechat` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `extend\savechat.smx` | 无同名 `.sp`；编译文件可用 |
| `sceneprocessor` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\sceneprocessor.smx` | 无同名 `.sp`；编译文件可用 |
| `SendFileExploitFixV2` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `SendFileExploitFixV2.smx` | 无同名 `.sp`；编译文件可用 |
| `server` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `optional\server.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/server.sp) |
| `server_ast` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `optional\server_ast.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/server_ast.sp) |
| `server_eazy` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `optional\server_eazy.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/server_eazy.sp) |
| `server_ht_party` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\server_ht_party.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/server_ht_party.sp) |
| `server_name` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\server_name.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/server_name.sp) |
| `server_name_coop` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\server_name_coop.smx` | [Anne-Neri source](D:/CodingFile/Anne-Neri/addons/sourcemod/scripting/server_name_coop.sp) |
| `server_si` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `optional\server_si.smx` | 无同名 `.sp`；编译文件可用 |
| `servercleanup` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `optional\servercleanup.smx` | 无同名 `.sp`；编译文件可用 |
| `ShieldTips` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\ShieldTips.smx` | 无同名 `.sp`；编译文件可用 |
| `si_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\si_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `skeeting_machine` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\skeeting_machine.smx` | 无同名 `.sp`；编译文件可用 |
| `smoker_anim_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\smoker_anim_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `sourcescramble_manager` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `sourcescramble_manager.smx` | 无同名 `.sp`；编译文件可用 |
| `spawnstatefix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\spawnstatefix.smx` | 无同名 `.sp`；编译文件可用 |
| `stop_tank_music` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\stop_tank_music.smx` | 无同名 `.sp`；编译文件可用 |
| `survivor_afk_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\survivor_afk_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `survivor_chat_select` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `extend\survivor_chat_select.smx` | 无同名 `.sp`；编译文件可用 |
| `Survivor_Legs` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `extend\Survivor_Legs.smx` | 无同名 `.sp`；编译文件可用 |
| `swamp_finale_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\swamp_finale_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `take_bot_items` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\take_bot_items.smx` | 无同名 `.sp`；编译文件可用 |
| `tank_announce` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\tank_announce.smx` | 无同名 `.sp`；编译文件可用 |
| `tank_music` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\tank_music.smx` | 无同名 `.sp`；编译文件可用 |
| `teleport_entity` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `teleport_entity.smx` | 无同名 `.sp`；编译文件可用 |
| `text_1128` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\text_1128.smx` | 无同名 `.sp`；编译文件可用 |
| `text_77` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\text_77.smx` | 无同名 `.sp`；编译文件可用 |
| `text_ast` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\text_ast.smx` | 无同名 `.sp`；编译文件可用 |
| `text_auto` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\text_auto.smx` | 无同名 `.sp`；编译文件可用 |
| `text_new` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\text_new.smx` | 无同名 `.sp`；编译文件可用 |
| `ThirdPersonShoulder_Detect` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `extend\ThirdPersonShoulder_Detect.smx` | 无同名 `.sp`；编译文件可用 |
| `tls_restore_vocalize` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\tls_restore_vocalize.smx` | 无同名 `.sp`；编译文件可用 |
| `transition_restore_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\transition_restore_fix.smx` | 无同名 `.sp`；编译文件可用 |
| `updater` | 服务器管理/实用工具；具体命令与行为需看源码（按插件名判断）。 | `extend\updater.smx` | 无同名 `.sp`；编译文件可用 |
| `vote_new` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\vote_new.smx` | 无同名 `.sp`；编译文件可用 |
| `votespec` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\votespec.smx` | 无同名 `.sp`；编译文件可用 |
| `WeaponHandling` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `extend\WeaponHandling.smx` | 无同名 `.sp`；编译文件可用 |
| `witch_announce` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\witch_announce.smx` | 无同名 `.sp`；编译文件可用 |
| `Witch_Double_Startle_Fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\Witch_Double_Startle_Fix.smx` | 无同名 `.sp`；编译文件可用 |
| `witch_glow` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\witch_glow.smx` | 无同名 `.sp`；编译文件可用 |
| `witch_prevent_target_loss` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\witch_prevent_target_loss.smx` | 无同名 `.sp`；编译文件可用 |
| `Witch_Target_patch` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `extend\Witch_Target_patch.smx` | 无同名 `.sp`；编译文件可用 |

## 仅 Zonemod 有（212）

| 插件 | 用途 | `.smx` 位置 | 对应源码 |
|---|---|---|---|
| `1v1` | 源码描述：A plugin designed to support 1v1. | `optional\1v1.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/1v1.sp) |
| `1vai` | 源码描述：A plugin designed to support 1vAI. | `optional\1vai.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/1vai.sp) |
| `8ball` | 源码描述：Simple 8Ball Game Plugin. Works the same as Coinflip / Dice Roll. | `optional\8ball.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/8ball.sp) |
| `aitankgank` | 源码描述：Kills tanks on pass to AI. | `optional\aitankgank.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/aitankgank.sp) |
| `annoyance_exploit_fixes` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\annoyance_exploit_fixes.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/annoyance_exploit_fixes.sp) |
| `Auto_Crash` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `Auto_Crash.smx` | 无同名 `.sp`；编译文件可用 |
| `autopause` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\autopause.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/autopause.sp) |
| `blockheatseekingchargers` | 源码描述：Blocks heatseeking chargers | `optional\blockheatseekingchargers.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/blockheatseekingchargers.sp) |
| `blocktrolls` | 源码描述：Prevents calling votes while others are loading | `optional\blocktrolls.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/blocktrolls.sp) |
| `boomer_horde_equalizer_refactored` | 源码描述：Fixes boomer hordes being different sizes based on wandering commons (1.5) as well as adding zombies to the queue rather than relying on max_mob_size | `optional\boomer_horde_equalizer_refactored.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/boomer_horde_equalizer_refactored.sp) |
| `bossspawningfix` | 源码描述：Makes Versus Boss Spawns obey cvars | `optional\bossspawningfix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/bossspawningfix.sp) |
| `caster_assister` | 源码描述：Allows spectators to control their own specspeed and move vertically | `optional\caster_assister.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/caster_assister.sp) |
| `caster_system` | 源码描述：Standalone caster handler. | `optional\caster_system.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/caster_system.sp) |
| `cfg_motd` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\cfg_motd.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/cfg_motd.sp) |
| `changelog` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\changelog.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/changelog.sp) |
| `charger_incap_damage` | 源码描述：Modify Charger pummel damage done to Survivors | `optional\charger_incap_damage.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/charger_incap_damage.sp) |
| `chat-processor` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\chat-processor.smx` | 无同名 `.sp`；编译文件可用 |
| `checkpoint-rage-control` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\checkpoint-rage-control.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/checkpoint-rage-control.sp) |
| `christmas_surprise` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\christmas_surprise.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/christmas_surprise.sp) |
| `coinflip` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\coinflip.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/coinflip.sp) |
| `despawn_health` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\despawn_health.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/despawn_health.sp) |
| `dingshot` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\dingshot.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/dingshot.sp) |
| `drop_secondary` | 源码描述：Survivor players will drop their secondary weapon when they die | `drop_secondary.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/drop_secondary.sp) |
| `enhancedsprays` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\enhancedsprays.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/enhancedsprays.sp) |
| `finale_tank_blocker` | 源码描述：Blocks even-numbered non-flow finale tanks. | `optional\finale_tank_blocker.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/finale_tank_blocker.sp) |
| `finalefix` | 源码描述：Kills survivors before the score is calculated so you don't get full distance if you are incapped as the rescue vehicle leaves. | `optional\finalefix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/finalefix.sp) |
| `firebulletsfix` | 源码描述：Fixes shoot position | `fixes\firebulletsfix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/firebulletsfix.sp) |
| `fix_engine` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\fix_engine.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/fix_engine.sp) |
| `fix_pill_pass` | 源码描述：Fixes being unable to pass Pills to Survivor considered 'In Combat' + Pills being thrown away. | `optional\fix_pill_pass.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/fix_pill_pass.sp) |
| `frozen_tank_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\frozen_tank_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/frozen_tank_fix.sp) |
| `GetPlayerGametime` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `GetPlayerGametime.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/GetPlayerGametime.sp) |
| `ghost_hurt` | 源码描述：Allows for modifications of trigger_hurt_ghost | `optional\ghost_hurt.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/ghost_hurt.sp) |
| `hextags` | 源码描述：Edit Tags & Colors! | `optional\hextags.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/hextags.sp) |
| `holdout_bonus` | 源码描述：Gives bonus for (partially) surviving holdout/camping events. (Requires penalty_bonus.) | `optional\holdout_bonus.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/holdout_bonus.sp) |
| `join` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\join.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_backjump_fix` | 源码描述：Fix hunter being unable to pounce off non-static props | `fixes\l4d_backjump_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_backjump_fix.sp) |
| `l4d_blackandwhite` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\l4d_blackandwhite.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_blackandwhite.sp) |
| `l4d_ci_ffblock` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d_ci_ffblock.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_ci_ffblock.sp) |
| `l4d_climb` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d_climb.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_climb.sp) |
| `l4d_consistent_escaperoute` | 源码描述：True L4D. | `fixes\l4d_consistent_escaperoute.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_consistent_escaperoute.sp) |
| `l4d_drop` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `l4d_drop.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_drop.sp) |
| `l4d_equalise_alarm_cars` | 源码描述：Make the alarmed car and its color spawns the same for each team in versus | `optional\l4d_equalise_alarm_cars.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_equalise_alarm_cars.sp) |
| `l4d_ffannounce` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\l4d_ffannounce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_ffannounce.sp) |
| `l4d_fix_common_shove` | 源码描述：Fix commons being immune to shoves when crouching, falling and landing. | `fixes\l4d_fix_common_shove.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_common_shove.sp) |
| `l4d_fix_deathfall_cam` | 源码描述：Prevent \ | `fixes\l4d_fix_deathfall_cam.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_deathfall_cam.sp) |
| `l4d_fix_finale_breakable` | 源码描述：Fix SI being unable to break props/walls within finale area before finale starts. | `fixes\l4d_fix_finale_breakable.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_finale_breakable.sp) |
| `l4d_fix_prop_los` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d_fix_prop_los.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_prop_los.sp) |
| `l4d_fix_punch_block` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d_fix_punch_block.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_punch_block.sp) |
| `l4d_fix_rocket_jump` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d_fix_rocket_jump.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_rocket_jump.sp) |
| `l4d_fix_rotated_physblocker` | 源码描述：Fix rotated \ | `fixes\l4d_fix_rotated_physblocker.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_rotated_physblocker.sp) |
| `l4d_fix_saferoom_ghostspawn` | 源码描述：Fix a glitch that ghost can spawn in saferoom while it shouldn't. | `fixes\l4d_fix_saferoom_ghostspawn.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_saferoom_ghostspawn.sp) |
| `l4d_fix_shove_duration` | 源码描述：Fix SI getting shoved by \ | `fixes\l4d_fix_shove_duration.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_shove_duration.sp) |
| `l4d_fix_stagger_dir` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d_fix_stagger_dir.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fix_stagger_dir.sp) |
| `l4d_fyzb_en_v20` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d_fyzb_en_v20.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_fyzb_en_v20.sp) |
| `l4d_heartbeat` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `l4d_heartbeat.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_heartbeat.sp) |
| `l4d_jockey_ledgehang` | 源码描述：Adds a cvar to adjust the recharge timer of a jockey after he ledge hangs a survivor. | `optional\l4d_jockey_ledgehang.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_jockey_ledgehang.sp) |
| `l4d_jump_beamring` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d_jump_beamring.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_laser_sp` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d_laser_sp.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d_mapbased_cvars` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\l4d_mapbased_cvars.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_mapbased_cvars.sp) |
| `l4d_pig_infected_notify` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `l4d_pig_infected_notify.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_pig_infected_notify.sp) |
| `l4d_pig_infected_notify_advanced` | 源码描述：Reports Boomer accidents, Witch kills and infected control steals | `optional\l4d_pig_infected_notify_advanced.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_pig_infected_notify_advanced.sp) |
| `l4d_prop_touching_rules` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `fixes\l4d_prop_touching_rules.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_prop_touching_rules.sp) |
| `l4d_return_thrown_items` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d_return_thrown_items.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_return_thrown_items.sp) |
| `l4d_skip_intro` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `fixes\l4d_skip_intro.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_skip_intro.sp) |
| `l4d_spectator_prefix` | 源码描述：when player in spec team, add prefix | `optional\l4d_spectator_prefix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_spectator_prefix.sp) |
| `l4d_static_punch_getup` | 源码描述：Fix punch get-up varying in length, along with flexible setting to it. | `fixes\l4d_static_punch_getup.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_static_punch_getup.sp) |
| `l4d_tank_painfade` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d_tank_painfade.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_tank_painfade.sp) |
| `l4d_tank_rush` | 源码描述：Stops distance points accumulating whilst the tank is alive, with the option of unfreezing distance on reaching the Saferoom | `optional\l4d_tank_rush.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_tank_rush.sp) |
| `l4d_tankpunchstuckfix` | 源码描述：Fixes the problem where tank-punches get a survivor stuck in the roof. | `optional\l4d_tankpunchstuckfix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_tankpunchstuckfix.sp) |
| `l4d_texture_manager_block` | 源码描述：Kicks out clients who are potentially attempting to enable mathack | `optional\l4d_texture_manager_block.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_texture_manager_block.sp) |
| `l4d_thirdpersonshoulderblock` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d_thirdpersonshoulderblock.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_thirdpersonshoulderblock.sp) |
| `l4d_tongue_bend_fix` | 源码描述：Fix unexpected tongue breaks for \ | `fixes\l4d_tongue_bend_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_tongue_bend_fix.sp) |
| `l4d_tongue_block_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d_tongue_block_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_tongue_block_fix.sp) |
| `l4d_tongue_float_fix` | 源码描述：Fix tongue instant choking survivors. | `fixes\l4d_tongue_float_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_tongue_float_fix.sp) |
| `l4d_votepoll_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d_votepoll_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_votepoll_fix.sp) |
| `l4d_witch_damage_announce` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d_witch_damage_announce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d_witch_damage_announce.sp) |
| `l4d2_acidviz` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\applemod\l4d2_acidviz.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_acidviz.sp) |
| `l4d2_advertisements` | 源码描述：Display advertisements | `optional\l4d2_advertisements.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_advertisements.sp) |
| `l4d2_allow_cs_weapons` | 源码描述：Force weapon spawners to ignore the 'no_cs_weapons' KeyValue, allowing for CS weapons on every map. | `optional\l4d2_allow_cs_weapons.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_allow_cs_weapons.sp) |
| `l4d2_antibaiter` | 源码描述：Makes you think twice before attempting to bait that shit | `optional\l4d2_antibaiter.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_antibaiter.sp) |
| `l4d2_blind_infected` | 源码描述：Hides specified weapons from the infected team until they are (possibly) visible to one of the survivors to prevent SI scouting the map | `optional\l4d2_blind_infected.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_blind_infected.sp) |
| `l4d2_block_autoaim` | 源码描述：Strips Auto-Aim from the game entirely (disables controller aim-assist + patches an exploit) | `optional\l4d2_block_autoaim.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_block_autoaim.sp) |
| `l4d2_block_bot_pills` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_block_bot_pills.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_block_bot_pills.sp) |
| `l4d2_block_rocketjump` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `l4d2_block_rocketjump.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_block_rocketjump.sp) |
| `l4d2_boomer_ladder_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d2_boomer_ladder_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_boomer_ladder_fix.sp) |
| `l4d2_boomer_shenanigans` | 源码描述：Make sure Boomers are unable to bile Survivors during a stumble (basically reinforce shoves) | `fixes\l4d2_boomer_shenanigans.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_boomer_shenanigans.sp) |
| `l4d2_bw_rock_hit` | 源码描述：Stops rocks from passing through soon-to-be-dead Survivors | `optional\l4d2_bw_rock_hit.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_bw_rock_hit.sp) |
| `l4d2_byedoor` | 源码描述：Time to kill Saferoom Doors. | `optional\l4d2_byedoor.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_byedoor.sp) |
| `l4d2_car_alarm_hittable_fix` | 源码描述：Disables the Car Alarm when a Tank hittable hits the alarmed car and makes sure the Car Alarm triggers whenever a Survivor touches it | `fixes\l4d2_car_alarm_hittable_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_car_alarm_hittable_fix.sp) |
| `l4d2_character_fix` | 源码描述：Fixes character change exploit in 1v1, 2v2, 3v3 | `optional\l4d2_character_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_character_fix.sp) |
| `l4d2_charge_target_fix` | 源码描述：Fix multiple issues with charger targets. | `fixes\l4d2_charge_target_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_charge_target_fix.sp) |
| `l4d2_collision_adjustments` | 源码描述：Allows messing with pesky Collisions in Left 4 Dead 2 | `optional\l4d2_collision_adjustments.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_collision_adjustments.sp) |
| `l4d2_director_commonlimit_block` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_director_commonlimit_block.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_director_commonlimit_block.sp) |
| `l4d2_dominatorscontrol` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_dominatorscontrol.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_dominatorscontrol.sp) |
| `l4d2_drop_secondary` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_drop_secondary.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_drop_secondary.sp) |
| `l4d2_explosiondmg_prev` | 源码描述：No more explosion damage to the infected from entity | `fixes\l4d2_explosiondmg_prev.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_explosiondmg_prev.sp) |
| `l4d2_fireworks_noise_block` | 源码描述：Focus on SI! | `optional\l4d2_fireworks_noise_block.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_fireworks_noise_block.sp) |
| `l4d2_fix_changelevel` | 源码描述：Fix issues due to forced changelevel + resolve partial map names before the engine sees them. | `fixes\l4d2_fix_changelevel.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_fix_changelevel.sp) |
| `l4d2_fix_firsthit` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d2_fix_firsthit.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_fix_firsthit.sp) |
| `l4d2_fix_rocket_pull` | 源码描述：Fix smoker pull launching survivor up | `fixes\l4d2_fix_rocket_pull.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_fix_rocket_pull.sp) |
| `l4d2_fix_spawn_order` | 源码描述：Finally fix that pesky spawn rotation not being reliable | `optional\l4d2_fix_spawn_order.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_fix_spawn_order.sp) |
| `l4d2_fix_tank_rock_handoff` | 源码描述：Cancels tank rocks that are in the middle of a throw when passing to another player/AI. | `fixes\l4d2_fix_tank_rock_handoff.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_fix_tank_rock_handoff.sp) |
| `l4d2_fix_team_shuffle` | 源码描述：Fix teams shuffling during map switching | `fixes\l4d2_fix_team_shuffle.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_fix_team_shuffle.sp) |
| `l4d2_getup_fixes` | 源码描述：Fixes all double/missing get-up cases. | `optional\l4d2_getup_fixes.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_getup_fixes.sp) |
| `l4d2_getup_slide_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_getup_slide_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_getup_slide_fix.sp) |
| `l4d2_ghost_warp` | 源码描述：Allows infected to warp to survivors | `optional\l4d2_ghost_warp.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_ghost_warp.sp) |
| `l4d2_godframes_control_merge` | 源码描述：Allows for control of what gets godframed and what doesnt along with integrated FF Support from l4d2_survivor_ff (by dcx and Visor) and l4d2_shotgun_ff (by Visor) | `optional\l4d2_godframes_control_merge.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_godframes_control_merge.sp) |
| `l4d2_hittable_control` | 源码描述：Allows for customisation of hittable damage values (and debugging) | `optional\l4d2_hittable_control.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_hittable_control.sp) |
| `l4d2_hltv_crash_fix` | 源码描述：Prevents Exploit That Crashes Servers | `fixes\l4d2_hltv_crash_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_hltv_crash_fix.sp) |
| `l4d2_horde` | 源码描述：Modifies Event Horde sizes and stops it completely during Tank | `optional\l4d2_horde.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_horde.sp) |
| `l4d2_hybrid_scoremod` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_hybrid_scoremod.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_hybrid_scoremod.sp) |
| `l4d2_hybrid_scoremod_zone` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_hybrid_scoremod_zone.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_hybrid_scoremod_zone.sp) |
| `l4d2_incap_fire_fix` | 源码描述：Lets incapacitated survivors fire their weapon normally (with sound) while holding shove | `fixes\l4d2_incap_fire_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_incap_fire_fix.sp) |
| `l4d2_jockey_jumpcap_patch` | 源码描述：Prevent Jockeys from being able to land caps with non-ability jumps in unfair situations | `fixes\l4d2_jockey_jumpcap_patch.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_jockey_jumpcap_patch.sp) |
| `l4d2_join_geoip_announce` | 源码描述：Queries the UAPI IP service and announces a player's province and city before the playtime message. | `optional\l4d2_join_geoip_announce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_join_geoip_announce.sp) |
| `l4d2_karma_kill` | 源码描述：Very Very loudly announces the predicted event of a player leaving the map and or life through height or drown. | `l4d2_karma_kill.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_karma_kill.sp) |
| `l4d2_ladderblock` | 源码描述：Prevents people from blocking players who climb on the ladder. | `fixes\l4d2_ladderblock.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_ladderblock.sp) |
| `l4d2_lagcomp_manager` | 源码描述：Provides lag compensation for entities in left 4 dead 2 (required enable sv_unlag). | `fixes\l4d2_lagcomp_manager.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_lagcomp_manager.sp) |
| `l4d2_ledgeblock` | 源码描述：Blocks ledge hanging on various maps | `optional\l4d2_ledgeblock.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_ledgeblock.sp) |
| `l4d2_m2_control_eq` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_m2_control_eq.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_m2_control_eq.sp) |
| `l4d2_magnum_incap` | 源码描述：Replace magnum with regular pistols when incapped. | `optional\l4d2_magnum_incap.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_magnum_incap.sp) |
| `l4d2_map_transitions` | 源码描述：Define map transitions to combine campaigns | `optional\l4d2_map_transitions.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_map_transitions.sp) |
| `l4d2_melee_damage_control` | 源码描述：Fix melees weapons not applying correct damage values on infected. Allows manipulate melee damage on some infected. | `fixes\l4d2_melee_damage_control.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_melee_damage_control.sp) |
| `l4d2_mix` | 源码描述：Provides ability to pick captains and teams through menus | `optional\l4d2_mix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_mix.sp) |
| `l4d2_mixmap` | 源码描述：Randomly select five maps for versus. Adding for fun and reference from CMT | `optional\l4d2_mixmap.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_mixmap.sp) |
| `l4d2_multi_witches` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_multi_witches.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_multi_witches.sp) |
| `l4d2_musicbox` | 源码描述：Per-map music box selection and round outcome music for L4D2 versus. | `optional\l4d2_musicbox.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_musicbox.sp) |
| `l4d2_network_monitor` | 源码描述：Shows connected players' latency, packet loss, and choke. | `optional\l4d2_network_monitor.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_network_monitor.sp) |
| `l4d2_no_m2_pulled_and_hunters` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_no_m2_pulled_and_hunters.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_no_m2_pulled_and_hunters.sp) |
| `l4d2_no_post_jockey_deadstops` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `fixes\l4d2_no_post_jockey_deadstops.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_no_post_jockey_deadstops.sp) |
| `l4d2_nobackjumps` | 源码描述：Look at the title | `optional\l4d2_nobackjumps.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_nobackjumps.sp) |
| `l4d2_nobhaps` | 源码描述：Stops bunnyhops by restricting speed when a player lands on the ground to their MaxSpeed | `optional\l4d2_nobhaps.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_nobhaps.sp) |
| `l4d2_noghostcheat` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `anticheat\l4d2_noghostcheat.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_noghostcheat.sp) |
| `l4d2_nosecondchances` | 源码描述：Previously human-controlled SI bots with a cap won't die | `optional\l4d2_nosecondchances.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_nosecondchances.sp) |
| `l4d2_nosey_parker` | 源码描述：Survivors receive damage reports after they get capped | `optional\l4d2_nosey_parker.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_nosey_parker.sp) |
| `l4d2_nospitterduringtank` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_nospitterduringtank.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_nospitterduringtank.sp) |
| `l4d2_notankautoaim` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_notankautoaim.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_notankautoaim.sp) |
| `l4d2_null_cusercmd_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d2_null_cusercmd_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_null_cusercmd_fix.sp) |
| `l4d2_penalty_bonus` | 源码描述：Allows other plugins to set bonuses for a round that will be given even if the saferoom is not reached. | `optional\l4d2_penalty_bonus.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_penalty_bonus.sp) |
| `l4d2_pistol_delay` | 源码描述：Allows you to adjust the rate of fire of pistols (with a high tickrate, the rate of fire of dual pistols is very high). | `fixes\l4d2_pistol_delay.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_pistol_delay.sp) |
| `l4d2_player_time` | 位于 disabled 子目录，按目录标记为停用；插件用途见文件名，包内带有编译文件。 | `disabled\l4d2_player_time.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_playstats` | 源码描述：Tracks statistics, even when clients disconnect. MVP, Skills, Accuracy, etc. | `optional\l4d2_playstats.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_playstats.sp) |
| `l4d2_profitless_ai_tank` | 源码描述：Passing control to AI Tank will no longer be rewarded with an instant respawn | `optional\l4d2_profitless_ai_tank.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_profitless_ai_tank.sp) |
| `l4d2_random_glow_item` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\l4d2_random_glow_item.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_riotcops` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_riotcops.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_riotcops.sp) |
| `l4d2_rock_trace_unblock` | 源码描述：Prevent hunter/jockey/coinciding survivor from blocking the rock radius check. | `fixes\l4d2_rock_trace_unblock.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_rock_trace_unblock.sp) |
| `l4d2_score_difference` | 源码描述：ez | `optional\l4d2_score_difference.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_score_difference.sp) |
| `l4d2_scoremod` | 源码描述：L4D2 Custom Scoring System (Health Bonus) | `optional\l4d2_scoremod.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_scoremod.sp) |
| `l4d2_scripted_tank_stage_fix` | 源码描述：Fix some issues of skipping stages regarding Tanks in finale. | `fixes\l4d2_scripted_tank_stage_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_scripted_tank_stage_fix.sp) |
| `l4d2_server_name` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\l4d2_server_name.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_server_name.sp) |
| `l4d2_setscores` | 源码描述：Changes team scores. | `optional\l4d2_setscores.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_setscores.sp) |
| `l4d2_shadow_removal` | 源码描述：A plugin that removes Shadows so that Survivors can't see Infected Players their shadows through walls and the like. | `fixes\l4d2_shadow_removal.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_shadow_removal.sp) |
| `l4d2_shove_fix` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d2_shove_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_shove_fix.sp) |
| `l4d2_si_control_health` | 源码描述：Tells a controlled survivor how much health the controlling special infected has left. | `optional\l4d2_si_control_health.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_si_control_health.sp) |
| `l4d2_skill_detect_advanced` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_skill_detect_advanced.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_skill_detect_advanced.sp) |
| `l4d2_sniper_bodyshot` | 源码描述：Remove sniper weapons' stomach hitgroup damage multiplier against hunters | `optional\l4d2_sniper_bodyshot.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_sniper_bodyshot.sp) |
| `l4d2_sniper_precache` | 源码描述：Unlocks German sniper weapons | `optional\l4d2_sniper_precache.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_sniper_precache.sp) |
| `l4d2_solidhealthmedkits` | 调整文件名所指的武器、物品、装备或补给行为（按插件名判断）。 | `optional\l4d2_solidhealthmedkits.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_solidhealthmedkits.sp) |
| `l4d2_sounds_blocker` | 源码描述：Blocks out more annoying sounds and allows the option for blocking custom sounds. Designed for NextMod Config. | `optional\l4d2_sounds_blocker.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_sounds_blocker.sp) |
| `l4d2_spit_cooldown_frozen_fix` | 源码描述：Simple fix for spit cooldown being \ | `fixes\l4d2_spit_cooldown_frozen_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_spit_cooldown_frozen_fix.sp) |
| `l4d2_steady_boost` | 源码描述：Prevent forced sliding when landing at head of enemies. | `optional\l4d2_steady_boost.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_steady_boost.sp) |
| `l4d2_tank_announce` | 源码描述：Announce in chat and via a sound when a Tank has spawned | `optional\l4d2_tank_announce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_announce.sp) |
| `l4d2_tank_facts_announce` | 源码描述：Announce damage dealt to survivors by tank | `optional\l4d2_tank_facts_announce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_facts_announce.sp) |
| `l4d2_tank_flying_incap` | 源码描述：Sends Survivors flying on the incapping punch. | `fixes\l4d2_tank_flying_incap.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_flying_incap.sp) |
| `l4d2_tank_melee_fury` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_tank_melee_fury.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_melee_fury.sp) |
| `l4d2_tank_props_brief_glow` | 源码描述：Briefly highlight Tank props when Tank spawns | `optional\l4d2_tank_props_brief_glow.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_props_brief_glow.sp) |
| `l4d2_tank_props_glow` | 源码描述：Stop tank props from fading whilst the tank is alive + add Hittable Glow. | `optional\l4d2_tank_props_glow.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_props_glow.sp) |
| `l4d2_tank_spawn_antirock_protect` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `fixes\l4d2_tank_spawn_antirock_protect.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_spawn_antirock_protect.sp) |
| `l4d2_tank_swap` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_tank_swap.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tank_swap.sp) |
| `l4d2_tankrage` | 源码描述：Manage Tank Rage when Survivors are running back. | `optional\l4d2_tankrage.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tankrage.sp) |
| `l4d2_tongue_timer` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_tongue_timer.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_tongue_timer.sp) |
| `l4d2_ultra_witch` | 源码描述：The Witch's hit deals a set amount of damage instead of instantly incapping, while also sending the survivor flying. Fixes convar z_witch_damage | `optional\l4d2_ultra_witch.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_ultra_witch.sp) |
| `l4d2_uncommon_adjustment` | 源码描述：Custom adjustments to uncommon infected. | `optional\l4d2_uncommon_adjustment.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_uncommon_adjustment.sp) |
| `l4d2_uncommon_blocker` | 修复、阻止或调整文件名所指的游戏行为/漏洞（按插件名判断）。 | `optional\l4d2_uncommon_blocker.smx` | 无同名 `.sp`；编译文件可用 |
| `l4d2_unreservelobby` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d2_unreservelobby.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_unreservelobby.sp) |
| `l4d2_vote` | 源码描述：vote for maps, hp, kick, spec | `optional\l4d2_vote.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_vote.sp) |
| `l4d2_weaponrules` | 源码描述：^ | `optional\l4d2_weaponrules.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_weaponrules.sp) |
| `l4d2_witch_glow` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\l4d2_witch_glow.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/l4d2_witch_glow.sp) |
| `l4d3_scoremod_DRDK_remake3` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\l4d3_scoremod_DRDK_remake3.smx` | 无同名 `.sp`；编译文件可用 |
| `LMC_Black_and_White_Notifier` | 源码描述：Notify people when player is black and white (Support LMC model if any) | `LMC_Black_and_White_Notifier.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/LMC_Black_and_White_Notifier.sp) |
| `mvp` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\mvp.smx` | 无同名 `.sp`；编译文件可用 |
| `nm3_ladder_damage` | 源码描述：Blocks players getting incapped from full hp on the ladder. | `optional\nm3_ladder_damage.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/nm3_ladder_damage.sp) |
| `nodeathcamskip` | 源码描述：Blocks players skipping their death time by going spec | `optional\nodeathcamskip.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/nodeathcamskip.sp) |
| `panel_text` | 源码描述：Displays custom text in the readyup panel. Spanks for the help CanadaRox! | `optional\panel_text.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/panel_text.sp) |
| `pause` | 源码描述：Adds pause functionality without breaking pauses, also prevents SI from spawning because of the Pause. | `optional\pause.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/pause.sp) |
| `player_fakelag` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\player_fakelag.smx` | 无同名 `.sp`；编译文件可用 |
| `playermanagement` | 源码描述：Player management!  Swap players/teams and spectate! | `optional\playermanagement.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/playermanagement.sp) |
| `pounce_maxdamage` | 提供文件名所指的统计、提示、界面、聊天、声音或外观功能（按插件名判断）。 | `optional\pounce_maxdamage.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/pounce_maxdamage.sp) |
| `pounceannounce` | 位于 disabled 子目录，按目录标记为停用；插件用途见文件名，包内带有编译文件。 | `disabled\pounceannounce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/pounceannounce.sp) |
| `predictable_unloader` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\predictable_unloader.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/predictable_unloader.sp) |
| `ratemonitor` | 源码描述：Keep track of players' netsettings | `optional\ratemonitor.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/ratemonitor.sp) |
| `rock_stumble_block` | 源码描述：Fixes rocks disappearing if tank gets stumbled while throwing. | `optional\rock_stumble_block.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/rock_stumble_block.sp) |
| `saferoom_gnome` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\saferoom_gnome.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/saferoom_gnome.sp) |
| `show_mic` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `show_mic.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/show_mic.sp) |
| `si_class_announce` | 源码描述：Report what SI classes are up when the round starts. | `optional\si_class_announce.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/si_class_announce.sp) |
| `si_fire_immunity` | 源码描述：Special Infected fire damage management. | `optional\si_fire_immunity.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/si_fire_immunity.sp) |
| `simple_witch_bonus` | 源码描述：Adds round bonus for Witch kills and a penalty for Witch incapacitations. | `optional\simple_witch_bonus.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/simple_witch_bonus.sp) |
| `SpecLister3.1` | 源代码没有可用的简短功能说明；这里仅按插件名初步归类，需进一步读实现确认。 | `optional\SpecLister3.1.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/SpecLister3.1.sp) |
| `staggersolver` | 源码描述：Blocks all button presses and restarts animations during stumbles | `optional\staggersolver.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/staggersolver.sp) |
| `sv_consistency_fix` | 源码描述：Fixes multiple sv_consistency issues. | `fixes\sv_consistency_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/sv_consistency_fix.sp) |
| `tank_witch_spawn_notify` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `optional\tank_witch_spawn_notify.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/tank_witch_spawn_notify.sp) |
| `teamflip` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\teamflip.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/teamflip.sp) |
| `temphealthfix` | 源码描述：Ensures that survivors that have been incapacitated with a hittable or ledged get their temp health set correctly | `optional\temphealthfix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/temphealthfix.sp) |
| `trigger_horde_notify` | 调整或提示文件名所指特感/尸潮的行为、数值或显示（按插件名判断）。 | `trigger_horde_notify.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/trigger_horde_notify.sp) |
| `versus_coop_mode` | 提供文件名所指的投票、地图、人数、队伍或玩法模式功能（按插件名判断）。 | `optional\versus_coop_mode.smx` | 无同名 `.sp`；编译文件可用 |
| `visualise_impacts` | 源码描述：Shows bullet impacts (based on the original by Jahze, fully rewritten and improved) | `optional\visualise_impacts.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/visualise_impacts.sp) |
| `weapon_loadout_vote` | 源码描述：Allows the Players to choose which weapons to play the mode in. | `optional\weapon_loadout_vote.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/weapon_loadout_vote.sp) |
| `weapon_spawn_duplicate_fix` | 源码描述：Prevents a weapon to be taken from weapon spawn if its item counter has hit a zero | `fixes\weapon_spawn_duplicate_fix.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/weapon_spawn_duplicate_fix.sp) |
| `witch_on_incap` | 源码描述：Spawns a witch anytime someone goes down! | `optional\witch_on_incap.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/witch_on_incap.sp) |
| `zm1v4_control_release` | 源码描述：Ends 1v4 infected pins with one point of damage after the survivor is pinned | `optional\zm1v4_control_release.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/zm1v4_control_release.sp) |
| `zm1v4_infected_slots` | 源码描述：Allows the 1v4 mode to use its available server slots for infected players | `optional\zm1v4_infected_slots.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/zm1v4_infected_slots.sp) |
| `zm1v4_si_rightclick_switch` | 源码描述：Right click to switch special infected class while in ghost state | `optional\zm1v4_si_rightclick_switch.smx` | [Zonemod source](D:/CodingFile/Zonemod/addons/sourcemod/scripting/zm1v4_si_rightclick_switch.sp) |

