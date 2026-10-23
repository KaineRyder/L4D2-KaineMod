## 1. 更新 KaineMod 人数与武器刷新规则

- [x] 1.1 在 KaineMod 4v4、3v3、2v2、1v1 和 Quad 配置中统一将马格南上限设为 2，并保留冲锋枪组上限 3、狙击枪组上限 1。
- [x] 1.2 将 KaineMod 各人数模式的 Hunter 上限统一设为 2。
- [x] 1.3 调整 Kaine 武器转换规则，让沙漠步枪刷新点出现 MP5，并避免 MP5 再转换为消音 SMG。
- [x] 1.4 保留并核对地图狙击枪刷新点转为木狙的规则，处理会阻止木狙自然刷新的配置。
- [x] 1.5 禁用 KaineMod 倒地马格南替换功能，使持有马格南的生还者倒地后仍保留马格南。
- [x] 1.6 为倒地状态的 Magnum 增加专属状态调整：散布增加 25%、射击间隔延长 20%；起身时恢复，伤害与衰减保持不变。

## 2. 调整 KaineMod 武器属性

- [x] 2.1 Configure Uzi (`weapon_smg`): damage 20, range modifier 0.85, range 2300, duck/standing spread 0.7/1.0, MaxSpread 28, MaxMovementSpread 2.0, clip 50, reload 1.7 s.
- [x] 2.2 Configure silenced SMG (`weapon_smg_silenced`): damage 29, modifier 0.63, range 2100, GainRange 900, duck/standing spread 0.85/1.2, MaxSpread 30, MaxMovementSpread 2.35, clip 50, reload 2.27 s.
- [x] 2.3 Configure MP5 (`weapon_smg_mp5`): damage 24, modifier 0.83, range 2100, duck/standing spread 0.75/1.1, MaxSpread 30, MaxMovementSpread 2.35, clip 60, reload 2.3 s.
- [x] 2.4 Configure Hunting Rifle and Military Sniper with damage 60, range modifier 1.0, range 8192, no distance attenuation, duck/standing spread 0/0.1, MaxSpread 3, clip 15.
- [x] 2.5 Configure Scout with damage 100, modifier 0.9, range 4000, GainRange 400, duck/standing spread 0/0.1, MaxSpread 4.05, clip 10.
- [x] 2.6 Configure AWP with damage 120, modifier 0.8, range 4000, GainRange 1000, duck/standing spread 0/0, MaxSpread 10, clip 6.
- [x] 2.7 Check supported attributes and consistent final values across Kaine modes and Quad, preserving existing cycle times and Tank multipliers.

## 3. 仅为 KaineMod 机关尸潮启用有限额度

- [x] 3.1 先核实当前尸潮插件/回调能否识别机关触发的 crescendo 事件，并与警报车、救援关/最终关尸潮区分；不得直接使用会全图限制所有尸潮的通用额度逻辑。
- [x] 3.2 若现有插件无法可靠区分来源，实现或扩展 Kaine 专用逻辑：只统计并限制机关事件生成的普通感染者；警报车、救援关等待与逃离阶段以及 Boomer 尸潮不受限制、不计数、不显示机关额度提示。
- [x] 3.3 在 KaineMod 五种模式启用上述机关事件逻辑，ZoneMod、ZoneMod Quad、AppleMod 及其他模式的插件清单和配置保持不变。
- [x] 3.4 逐图审核 Kaine 五套 `mapinfo.txt` 中机关事件的专属额度；缺少专属额度时每局默认 150 个普通感染者，同一局内多个机关事件共用额度。
- [x] 3.5 为机关尸潮实现开始额度、剩余数量和额度耗尽提示；验证警报车与救援关尸潮不触发这些提示。
- [x] 3.6 核对额度耗尽只停止当前机关事件后续生成的普通感染者，不干预警报车尸潮及救援关/最终关流程。

## 4. 同步 KaineMod 文档

- [x] 4.1 更新 README 的模式说明、马格南与 Hunter 上限、MP5/木狙刷新、机关有限尸潮范围和倒地马格南说明。
- [x] 4.2 Sync README weapon values, including the three SMGs, four snipers, and weapon group caps.
- [x] 4.3 明确记录警报车尸潮和救援关尸潮保持原样，不受机关有限尸潮规则影响。
