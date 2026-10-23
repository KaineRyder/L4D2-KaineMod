## Why

KaineMod 的警报车提示目前把生还者触发警报车归类为「高光操作」，与服务器希望使用的提示分类不一致。另一个问题是玩家主动触发机关尸潮后，有限尸潮提示偶尔没有出现，导致玩家无法确认该事件已被系统识别及其额度。

## What Changes

- 将生还者触发警报车的中文提示分类改为「铸币操作」，并按要求调整名称与玩家名之间的空格；只改显示文本，不改该通知的源代码或触发行为。
- 修复 KaineMod 机关尸潮开始提示漏报，使有效的机关事件能及时显示有限尸潮额度提示。
- 保持警报车及救援/最终关尸潮不触发机关有限尸潮额度提示；其现有提示与尸潮行为维持不变。

## Capabilities

### New Capabilities
- `kaine-event-notices`: KaineMod 的中文警报车操作分类文案，以及机关尸潮开始提示的可靠显示行为。

### Modified Capabilities

## Impact

- `addons/sourcemod/translations/l4d2_skill_detect.phrases.txt`：生还者直接触发警报车时的中文提示文本。
- `addons/sourcemod/scripting/l4d2_kaine_finite_hordes.sp`：机关尸潮事件识别及开始提示逻辑。
- KaineMod 有限尸潮提示的现有短语资源及相关验证流程。
