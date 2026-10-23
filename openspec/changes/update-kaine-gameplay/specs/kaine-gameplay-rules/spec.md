## ADDED Requirements

### Requirement: KaineMod 自然刷新 MP5 与木狙
KaineMod SHALL 保留 MP5 和 Hunting Rifle 的地图自然刷新结果。MP5 SHALL NOT 在武器转换规则中被替换为消音 SMG；适用的沙漠步枪刷新点 SHALL 转换为 MP5。木狙 SHALL 可由地图现有狙击枪刷新点转换获得。

#### Scenario: 地图刷新 MP5
- **WHEN** KaineMod 加载包含 MP5 对应自然刷新点的地图
- **THEN** 生还者可获得 MP5，且该武器不会再次被转换为消音 SMG

#### Scenario: 地图刷新木狙
- **WHEN** KaineMod 加载包含 Hunting Rifle 或可转换狙击枪刷新点的地图
- **THEN** 生还者可获得 Hunting Rifle

### Requirement: 倒地时保留马格南
KaineMod SHALL 禁用倒地马格南替换为一把或双持普通小手枪的行为；倒地前持有马格南的生还者倒地后 SHALL 保留马格南。

#### Scenario: 持马格南倒地
- **WHEN** 生还者持有马格南并进入倒地状态
- **THEN** 马格南不会被替换为普通小手枪或双持小手枪

### Requirement: KaineMod 狙击枪采用指定属性
KaineMod SHALL 为四把狙击枪应用下列伤害、衰减、射程、加衰距离、蹲伏扩散、站立扩散、最大扩散及弹匣参数：Hunting Rifle 为 `60 / 1.0 / 8192 / 无衰减 / 0 / 0.1 / 3 / 15`；Military Sniper 为 `60 / 1.0 / 8192 / 无衰减 / 0 / 0.1 / 3 / 15`；Scout 为 `100 / 0.9 / 4000 / 400 / 0 / 0.1 / 4.05 / 10`；AWP 为 `120 / 0.8 / 4000 / 1000 / 0 / 0 / 10 / 6`。参数顺序依次对应前述字段。

#### Scenario: 读取 KaineMod 狙击枪参数
- **WHEN** 启用 KaineMod 并读取 Hunting Rifle、Military Sniper、Scout 或 AWP 的武器属性
- **THEN** 各武器的上述属性与指定值一致

### Requirement: KaineMod SMGs use the specified attributes
KaineMod SHALL configure Uzi (`weapon_smg`) with damage 20, `rangemod 0.85`, `range 2300`, `minduckspread 0.7`, `minstandspread 1.0`, `maxspread 28`, `maxmovespread 2.0`, `clipsize 50`, and `reloadduration 1.7`, without an explicit `gainrange`. KaineMod SHALL configure silenced SMG (`weapon_smg_silenced`) with damage 29, `rangemod 0.63`, `range 2100`, `gainrange 900`, `minduckspread 0.85`, `minstandspread 1.2`, `maxspread 30`, `maxmovespread 2.35`, `clipsize 50`, and `reloadduration 2.27`. KaineMod SHALL configure MP5 (`weapon_smg_mp5`) with damage 24, `rangemod 0.83`, `range 2100`, `minduckspread 0.75`, `minstandspread 1.1`, `maxspread 30`, `maxmovespread 2.35`, `clipsize 60`, and `reloadduration 2.3`, without an explicit `gainrange`.

#### Scenario: Fire Uzi
- **WHEN** a survivor fires the KaineMod Uzi
- **THEN** each bullet deals 20 damage and uses the specified range, spread, magazine, and reload values

#### Scenario: Fire silenced SMG
- **WHEN** a survivor fires the KaineMod silenced SMG
- **THEN** each bullet deals 29 damage and uses the specified range, spread, magazine, and reload values

#### Scenario: Fire MP5
- **WHEN** a survivor fires the KaineMod MP5
- **THEN** each bullet deals 24 damage and uses the specified range, spread, magazine, and reload values

zi（`weapon_smg`）的单颗弹丸伤害设为 **20**、`spreadpershot` 设为 **0.20**、`maxmovespread` 设为 **1.90**、`range` 设为 **3000**、`rangemod` 设为 **0.83**、`gainrange` 设为 **1000**。KaineMod SHALL 将消音 SMG（`weapon_smg_silenced`）的单颗弹丸伤害设为 **27**、`spreadpershot` 设为 **0.30**、`maxmovespread` 设为 **2.45**、`range` 设为 **3000**、`rangemod` 设为 **0.79**、`gainrange` 设为 **900**。Uzi 定位为低伤害、高准度的点射武器；消音 SMG 定位为中远距离爆发武器。

#### Scenario: 使用 Uzi 点射
- **WHEN** 生还者使用 KaineMod Uzi 射击
- **THEN** 单颗弹丸造成 20 点伤害，并应用 `0.20 / 1.90` 散布、`3000 / 0.83 / 1000` 射程/衰减/加衰距离

#### Scenario: 使用消音 SMG 连续射击
- **WHEN** 生还者使用 KaineMod 消音 SMG 连续射击
- **THEN** 单颗弹丸造成 27 点伤害，并应用 `0.30 / 2.45` 散布、`3000 / 0.79 / 900` 射程/衰减/加衰距离

### Requirement: 倒地马格南保留武器并降低倒地状态下的准度和射速
KaineMod SHALL 在倒地时保留 Magnum，不替换成双持小手枪。仅在倒地期间，Magnum 的散布 SHALL 在正常值上增加 25%，射击间隔 SHALL 延长 20%；马格南伤害和距离衰减 SHALL 保持正常值，起身后 SHALL 恢复正常散布和射击间隔。

#### Scenario: 玩家倒地时使用马格南
- **WHEN** 持有 Magnum 的生还者倒地并开火
- **THEN** 玩家仍持有 Magnum，散布增加 25%、射击间隔延长 20%，伤害与距离衰减不变

#### Scenario: 玩家起身
- **WHEN** 持有 Magnum 的生还者从倒地状态起身
- **THEN** Magnum 的散布与射击间隔恢复正常值
