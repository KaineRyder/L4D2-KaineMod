# isolated-zonemod-families Specification

## Purpose
TBD - created by archiving change separate-kaine-and-zonemod-configs. Update Purpose after archive.
## Requirements
### Requirement: 原生 ZoneMod 使用上游 2.9.2b 配置
模式配置 MUST 提供基于上游 ZoneMod 2.9.2b 的原生配置，并将其标记为 ZoneMod 2.9.2b。

#### Scenario: 选择原生 ZoneMod
- **WHEN** 加载 `zonemod` 模式
- **THEN** 系统执行原生 ZoneMod 2.9.2b 配置及其原生共享依赖

### Requirement: KaineMod 保留当前定制配置
在恢复原生 ZoneMod 文件之前，模式配置 MUST 将当前 ZoneMod 2.9.1b 工作区中确认属于现有玩法的定制内容保存在 KaineMod 专属路径。

#### Scenario: 更新原生 ZoneMod
- **WHEN** 上游 2.9.2b 配置替换原生 ZoneMod 文件
- **THEN** 已确认的 KaineMod 规则仍可通过 Kaine 专属文件使用，且不会被上游恢复操作覆盖

### Requirement: 原生与 Kaine 共享配置相互隔离
KaineMod 模式 MUST 加载 Kaine 专属玩法配置；原生 ZoneMod 模式 MUST 加载原生共享配置。更新原生 ZoneMod 共享文件 MUST NOT 改变 KaineMod 行为。

#### Scenario: 原生共享配置更新
- **WHEN** 未来为上游版本更新原生 ZoneMod 共享配置
- **THEN** KaineMod 模式仍通过 Kaine 专属路径加载自己的玩法配置

### Requirement: 保持现有原生模式 ID
现有 `zonemod`、`zm1v1`、`zm2v2` 和 `zm3v3` ID MUST 继续选择原生 ZoneMod 模式，且本次变更 MUST NOT 改变服务器现有默认模式。

#### Scenario: 使用现有原生模式选择器
- **WHEN** 现有服务器命令或流程选择上述任一 ID
- **THEN** 对应原生 ZoneMod 模式仍已注册，并加载各自的原生配置

### Requirement: 其他模式保持原有配置行为
迁移 MUST 保持原生 ZoneMod 和 KaineMod 之外的模式的有效配置行为；若必须调整共享依赖，则需明确记录，并确保调整后仍保留变更前的行为。

#### Scenario: 加载其他模式
- **WHEN** 加载非 ZoneMod、非 KaineMod 的模式
- **THEN** 该模式保留变更前的专属插件、变量、地图和卸载行为

