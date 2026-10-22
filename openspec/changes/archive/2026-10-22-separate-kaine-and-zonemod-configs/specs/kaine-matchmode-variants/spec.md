## ADDED Requirements

### Requirement: KaineMod 提供所需人数模式
模式注册表 MUST 提供独立的 KaineMod 4v4、3v3、2v2、1v1 和 Quad 模式，并使用能标明 KaineMod 及对应人数或类型的显示名称。

#### Scenario: 查看 KaineMod 模式列表
- **WHEN** 模式选择器读取 `matchmodes.txt`
- **THEN** 列表中分别显示 KaineMod 4v4、3v3、2v2、1v1 和 Quad 模式

### Requirement: KaineMod 人数变体使用独立配置
每个 KaineMod 模式 MUST 加载匹配人数的设置及 Kaine 专属依赖，包括 ReadyUp 名称、插件列表、变量、地图变量目录、Stripper 选择和适用的卸载配置。

#### Scenario: 加载 KaineMod 人数变体
- **WHEN** 选择 KaineMod 3v3、2v2 或 1v1 模式
- **THEN** 系统应用对应人数规则，并从 Kaine 专属路径加载玩法配置

### Requirement: KaineMod 各人数模式保留定制武器限制
所有 KaineMod 人数模式 MUST 将 MP5 纳入冲锋枪组上限 3，并将狙击枪组上限设为 1；狙击枪组 MUST 包含猎枪、Scout、军用狙击枪和 AWP。武器上限按插件统计当前存活生还者所持武器的总数。

#### Scenario: 加载任一 KaineMod 人数模式
- **WHEN** 选择 KaineMod 1v1、2v2、3v3、4v4 或 Quad 模式
- **THEN** MP5 按冲锋枪组总上限 3 管理，且当前存活生还者合计至多可持有 1 把狙击枪

### Requirement: KaineMod Quad 保留现有 Quad 规则
KaineMod Quad MUST 以当前 `zonemod4K` 玩法配置为基础，且 MUST NOT 在迁移时被原生 ZoneMod 2.9.2b 的普通 4v4 设置静默替换。

#### Scenario: 加载 KaineMod Quad
- **WHEN** 选择 KaineMod Quad 模式
- **THEN** 系统通过 Kaine 专属配置加载已保留的当前 4K/Quad 规则

### Requirement: 原生与 Kaine 模式名称清楚区分
模式名称和 ReadyUp 配置名称 MUST 区分原生 ZoneMod 2.9.2b 与 KaineMod，并区分 KaineMod 各人数模式和 Quad。

#### Scenario: 在选择器或 ReadyUp 中显示模式
- **WHEN** 显示已注册的原生 ZoneMod 或 KaineMod 模式
- **THEN** 显示名称能识别正确的配置家族、版本或人数类型
