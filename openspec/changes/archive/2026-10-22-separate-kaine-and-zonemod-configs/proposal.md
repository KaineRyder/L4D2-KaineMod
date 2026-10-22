## Why

仓库当前实际使用的 ZoneMod 2.9.1b 配置已经包含 Kaine 专属改动，共享配置也因此无法与上游 ZoneMod 独立维护。现在将现有玩法保存为 KaineMod，并把原生 ZoneMod 配置恢复到上游 2.9.2b，可以保留当前玩法，同时让后续 KaineMod 改动清晰、可审查。

## What Changes

- **BREAKING** 将当前确认过的 2.9.1b 定制玩法迁入 KaineMod 专属配置路径，不再留在原生 ZoneMod 配置中。
- 为 KaineMod 增加 4v4、3v3、2v2、1v1 和 Quad 模式。
- 从上游 2.9.2b 恢复原生 ZoneMod 配置，并单独注册原生模式。
- 拆分共享配置依赖：KaineMod 各模式使用 KaineMod 文件，原生 ZoneMod 使用上游文件；其他模式维持现有行为。
- 更新模式显示名称和版本标记，清楚区分原生 ZoneMod 2.9.2b 与 KaineMod 各模式。
- 在替换或迁移配置前记录 ZoneMod 2.9.1b 本地改动的来源，并将确认属于玩法定制的内容保留在 KaineMod 中。

## 能力范围

### 新增能力

- `isolated-zonemod-families`：定义原生 ZoneMod 与 KaineMod 的来源、注册方式和配置隔离要求。
- `kaine-matchmode-variants`：定义 KaineMod 4v4、3v3、2v2、1v1 和 Quad 模式的可用性及配置归属。

### 修改现有能力

无。

## 影响范围

- `addons/sourcemod/configs/matchmodes.txt` 和 `cfg/cfgogl/` 下的 ZoneMod 配置目录，包括 `zonemod`、`zonemod4K`、`zm3v3`、`zm2v2` 和 `zm1v1`。
- 目前导入 `cfgogl/zonemod` 共享文件的其他模式；实施时需核对，避免意外改变其行为。
- 上游来源：[SirPlease/L4D2-Competitive-Rework](https://github.com/SirPlease/L4D2-Competitive-Rework)。该仓库目前标注内含 ZoneMod 2.9.2b。
