## Context

KaineMod 已拆分为 `kainemod`、`kaine3v3`、`kaine2v2`、`kaine1v1` 和 `kaine4K` 配置。当前各模式的马格南、Hunter 上限与武器转换规则不一致；MP5 和木狙自然刷新也可能被转换配置覆盖。用户已给出四把狙击枪参数，并明确 Uzi 应定位为低伤害高准度、消音 SMG 定位为中远距离爆发。

尸潮范围已明确为机关触发的无限尸潮。警报车触发的尸潮和救援关/最终关尸潮必须保持原样。现有 `l4d2_horde_equaliser` 一类通用实现按地图/回合累计普通感染者，且刷新回调未必能区分尸潮来源；不能不经来源识别就直接启用，否则会把警报车或救援尸潮也纳入额度。

## Goals / Non-Goals

**Goals:**
- 在五种 KaineMod 模式统一马格南上限 2、Hunter 上限 2，并保留冲锋枪组上限 3、狙击枪组上限 1。
- 使 MP5 与木狙可在 KaineMod 地图自然刷新。
- 只限制玩家操作机关或守点事件触发的无限尸潮；同一局内所有机关事件共享地图额度。没有地图专属额度时，每局默认 150 个普通感染者。
- 机关尸潮开始、进度和额度耗尽时向玩家显示提示。
- 完全保留警报车尸潮、救援等待及逃离阶段尸潮、Boomer 尸潮的现有行为。
- 按用户给出的数值配置武器并同步 README。
- 不改动任何 ZoneMod 配置或其他非 KaineMod 模式。

**Non-Goals:**
- 不改变警报车尸潮或救援关/最终关尸潮的额度、生成节奏、提示或结束条件。
- 不限制 Boomer 吐口尸潮、管理员手动 `z_spawn` 等不属于机关事件的感染者来源。
- 不修改 ZoneMod、ZoneMod Quad、AppleMod 或其他非 KaineMod 配置。
- 不调整用户未列出的枪械或 Tank 倍率等玩法参数。

## Decisions

1. **机关尸潮使用整局共享计数。**
   每局开始时重置机关尸潮计数，并读取地图的 `horde_limit`；地图未配置该值时使用 150。该局中的多个机关事件共用这个计数和额度，重复触发不会重置已生成数量。警报车不能作为机关事件示例，因为它明确排除在本规则之外。

2. **按来源识别尸潮，再执行限额。**
   实现前先核查当前插件的生成回调是否能可靠区分机关 crescendo、警报车 panic 和 finale/rescue 阶段。若不能区分，则扩展或另写 Kaine 专用逻辑，结合机关事件生命周期识别当前事件。来源不明时不得把它计入机关额度，也不得停止其生成。额度耗尽仅阻止当前机关事件后续生成的普通感染者。

3. **警报车及救援尸潮不受干预。**
   警报车 panic、救援关等待阶段和逃离阶段的感染者既不应用机关额度，也不计入任何机关事件计数。不能以简单排除一个 finale 时段的方式误伤救援前的地图尸潮；事件分类必须基于触发来源/阶段。

4. **插件只在 KaineMod 模式启用。**
   在 `kainemod`、`kaine3v3`、`kaine2v2`、`kaine1v1`、`kaine4K` 启用机关有限尸潮逻辑。其他模式不加载该逻辑，也不读取 Kaine 额度。

5. **机关尸潮提示与计数使用同一事件状态。**
   开始提示显示当前机关事件额度，进度提示显示该事件剩余数量，额度耗尽提示只在该机关事件触发一次。警报车和救援尸潮不得显示这些提示。

6. **统一生还者与特殊感染者上限。**
   五种 KaineMod 配置的马格南总持有量设为 2，Hunter 上限设为 2；冲锋枪组维持 3 并包含 MP5，狙击枪组维持 1。调整武器转换规则，让原沙漠步枪刷新点可出现 MP5，且不将 MP5 再转成消音 SMG；继续保留狙击枪刷新点转木狙的规则，并排除阻止木狙自然刷新的转换。

7. **倒地时保留马格南并轻微削弱准度与射速。**
   将 `l4d2_replace_magnum_incap` 设为禁用值 0。倒地状态下 Magnum 的扩散在正常值基础上增加 25%，射击间隔延长 20%；伤害与距离衰减不变，起身后恢复正常。武器属性插件为全局静态属性，因此需要按持有者倒地/起身状态实施个体调整，不能用全局参数模拟倒地削弱。属性无法可靠按玩家隔离时，应先确认替代实现再纳入代码。

8. **应用用户指定的武器参数。**
   - Uzi (`weapon_smg`): damage 20, `rangemod 0.85`, `range 2300`, `minduckspread 0.7`, `minstandspread 1.0`, `maxspread 28`, `maxmovespread 2.0`, `clipsize 50`, `reloadduration 1.7`; no explicit `gainrange`.
   - Silenced SMG (`weapon_smg_silenced`): damage 29, `rangemod 0.63`, `range 2100`, `gainrange 900`, `minduckspread 0.85`, `minstandspread 1.2`, `maxspread 30`, `maxmovespread 2.35`, `clipsize 50`, `reloadduration 2.27`.
   - MP5 (`weapon_smg_mp5`): damage 24, `rangemod 0.83`, `range 2100`, `minduckspread 0.75`, `minstandspread 1.1`, `maxspread 30`, `maxmovespread 2.35`, `clipsize 60`, `reloadduration 2.3`; no explicit `gainrange`.
   - Hunting Rifle 与 Military Sniper：伤害 60，衰减 1.0，射程 8192，无距离衰减，蹲伏扩散 0、站立扩散 0.1、最大扩散 3，弹匣 15。
   - Scout：伤害 100，衰减 0.9，射程 4000，加衰距离 400，蹲伏扩散 0、站立扩散 0.1、最大扩散 4.05，弹匣 10。
   - AWP：伤害 120，衰减 0.8，射程 4000，加衰距离 1000，蹲伏和站立扩散 0、最大扩散 10，弹匣 6。
   保留与这些目标不冲突的射速和 Tank 倍率。

9. **README 只记录 KaineMod 最终有效规则。**
   同步模式说明、上限、刷新规则、机关有限尸潮边界、武器参数与倒地马格南行为，并明确警报车及救援关尸潮保持原样。

## Risks / Trade-offs

- **尸潮来源回调可能没有足够上下文。** 通用生成回调若无法判断机关/警报车/救援来源，误用会破坏用户要求。实现必须先审查源码；无法安全识别时，应增加可验证的事件状态跟踪，不可退化为全图总数限制。
- **地图专属额度可能尚未校准。** 未配置 `horde_limit` 时每局默认 150；保留按地图覆写的配置能力，后续根据实际地图规模调整。
- **倒地状态武器参数需要玩家级隔离。** 应使用状态变化逻辑并确保起身、死亡、换武器时恢复，避免影响其他持有马格南的玩家。

## Migration Plan

1. 核查并修改五种 KaineMod 模式的上限、刷新转换、武器属性和倒地马格南行为。
2. 核查尸潮插件对事件来源的识别能力；实现仅适用于机关事件的每局累计、限额及提示，并排除警报车与救援阶段。
3. 审核 KaineMod 地图机关事件额度；无专属配置时使用每局 150 的默认值。
4. 更新 README，使文档与最终配置一致。
5. 回滚时恢复受影响的 Kaine 文件，并移除新增的 Kaine 专用事件逻辑；ZoneMod 文件不参与迁移。

## Open Questions

- 倒地 Magnum 的散布增加 25% 和射击间隔延长 20% 是方案拟定的具体化数值；实现前如发现现有机制无法可靠按玩家隔离，需要在变更内提供可行实现方案。
- 默认额度为每局 150；地图已有 `horde_limit` 作为该地图每局所有机关事件共享的总额度。

## Implementation findings and revised approach

### Existing 1v1 configurations

- ZoneMod 1v1 (`zm1v1`) loads `l4d2_director_commonlimit_block`; it clamps scripted `CommonLimit` to `z_common_limit` (5). It does not implement a finite per-event quota.
- NextMod 1v1 (`nextmod1v1`) inherits `nextmod/shared_plugins.cfg`, which loads `l4d2_horde_equaliser`. That plugin reads the map's single `horde_limit`, counts commons against one round-wide counter, and uses the generic `L4D_OnSpawnMob` callback to stop requests. Its own source notes that the callback does not distinguish wanderers from active-event commons. This behavior is not suitable for Kaine's event-isolated requirement.

### Kaine-specific event limiter

- Add a Kaine-only plugin and load it from the shared plugin lists used by `kainemod` and `kaine4K`; the smaller Kaine modes inherit the former. Leave ZoneMod, NextMod, AppleMod, and all other plugin lists unchanged.
- Use `CDirector::OnMapInvokedPanicEvent`'s panic reason to open a new event context for scripted crescendo (reason 0) and classify alarm-car panic (reason 1) as pass-through. Each scripted trigger starts a fresh event counter. Finale-start signals disable the limiter for the rest of that finale/rescue sequence.
- Limit only the amount accepted by `L4D_OnSpawnMob` while the scripted event context and active mob timer agree. `L4D_OnSpawnITMob` is a separate Boomer-horde callback and remains untouched. Do not clear the director's pending mob queue at exhaustion; set the current event's later spawn request to zero so already accepted commons and unrelated horde flows are left alone.
- Reuse each Kaine mapinfo `horde_limit` value as that map's per-round shared crescendo quota, with 150 as the missing-key default. The value is loaded at map/round start; repeated scripted triggers share the same spawned count, which resets only at the next round/map start.
- The five Kaine mapinfo files were compared: `kainemod`, `kaine1v1`, `kaine2v2`, and `kaine3v3` share the same overrides. `kaine4K` has its own values. Preserve all configured values as per-round shared quotas; maps without an override use 150 per round.
- Show start, quarter-progress remaining, and one exhaustion message from the same event state. Alarm-car and finale paths return before counting or messaging.

### Incapacitated Magnum plugin

- Add a separate plugin loaded only in Kaine. Hook each Magnum entity's `CTerrorGun::GetRateOfFire` post-result and multiply the incapacitated owner's effective interval by 1.2. The engine's global `CycleTime`, damage, and range modifier remain unchanged; the multiplier applies only while that entity's owner is incapacitated.
- Around the server-side `CTerrorPlayer::FireBullet` call, temporarily scale Magnum spread attributes by 1.25 only for an incapacitated shooter, then restore their saved values in the post hook. This keeps the adjustment scoped to that synchronous firing call instead of leaving a global weapon-attribute change active. On revive, the condition no longer matches and both adjustments stop immediately.
- The spread hook is server-side and depends on the existing game signature; verify it on the supported server builds before treating the behavior as production-ready.
