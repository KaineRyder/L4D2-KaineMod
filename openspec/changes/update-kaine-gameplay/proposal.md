## Why

KaineMod 已从原生 ZoneMod 配置中分离，但武器刷新、人数上限、枪械属性、倒地副武器和机关尸潮规则仍需按 KaineMod 的玩法目标统一调整。本变更只调整 KaineMod；ZoneMod 配置保持原样。

## What Changes

- 将 KaineMod 4v4、3v3、2v2、1v1 和 Quad 的马格南持有上限调整为 2，Hunter 上限调整为 2；保留冲锋枪组上限 3 和狙击枪组上限 1。
- 调整 KaineMod 武器刷新规则，使 MP5 与木狙可以自然刷新。
- 仅将 KaineMod 中玩家操作机关或守点事件触发的无限尸潮改为有限尸潮；同一局内所有机关事件共享地图额度，缺少地图专属额度时默认 150 个普通感染者，并提供开始、剩余进度和额度耗尽提示。
- 警报车尸潮、救援关/最终关尸潮（包括等待与逃离阶段）以及 Boomer 吐口尸潮保持原有刷新行为，不受机关额度限制、不计入机关额度，也不显示机关尸潮提示。
- User-specified KaineMod SMG values: Uzi (`weapon_smg`) damage 20, range modifier 0.85, range 2300, duck/standing spread 0.7/1.0, MaxSpread 28, MaxMovementSpread 2.0, clip 50, reload 1.7 s; silenced SMG (`weapon_smg_silenced`) damage 29, modifier 0.63, range 2100, GainRange 900, duck/standing spread 0.85/1.2, MaxSpread 30, MaxMovementSpread 2.35, clip 50, reload 2.27 s; MP5 (`weapon_smg_mp5`) damage 24, modifier 0.83, range 2100, duck/standing spread 0.75/1.1, MaxSpread 30, MaxMovementSpread 2.35, clip 60, reload 2.3 s.
- 按用户提供的参数表统一 KaineMod 木狙、军狙、Scout 和 AWP 的伤害、衰减、射程、扩散及弹匣容量。
- 禁用 KaineMod 倒地马格南替换为双持小手枪的行为，改为倒地时保留马格南并轻微降低准度和射速；伤害与距离衰减不变。
- 更新 README 中 KaineMod 玩法说明和枪械数据，使文档与最终配置一致。

## Capabilities

### New Capabilities
- `kaine-gameplay-rules`：KaineMod 各人数模式的武器刷新、人数上限、枪械属性和倒地马格南行为。
- `finite-kaine-hordes`：只对机关触发的 KaineMod 尸潮设置每局共享额度及玩家提示，并明确排除警报车和救援关尸潮。

### Modified Capabilities
- `kaine-matchmode-variants`：更新各 KaineMod 人数模式的马格南和 Hunter 上限，同时保留现有冲锋枪组和狙击枪组限制。

## Impact

- 影响 `cfg/cfgogl/kainemod/`、`kaine3v3/`、`kaine2v2/`、`kaine1v1/`、`kaine4K/` 下的插件清单、模式设置、武器属性和地图信息，以及 README。
- 尸潮实现必须能识别机关事件来源。若现有通用插件不能将机关尸潮与警报车、救援关尸潮可靠区分，则需扩展或增加 Kaine 专用逻辑；不得用全图通用计数器替代。
- `zonemod/`、`zonemod4K/` 及其他非 KaineMod 模式不在本次修改范围内。
