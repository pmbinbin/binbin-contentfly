---
name: binbin-contentfly-showcase
description: |
  内容展示页生成器。将 Markdown 文章自动转换为双栏 HTML 展示页面，左侧为视觉展示（给观众看），右侧为口播文稿（给创作者念）。
  触发条件：(1)用户说"生成展示页"或"转成HTML"或"做演示文稿"，(2)用户说"/binbin-contentfly-showcase"，(3)用户想将文章转换为演示/展示格式。
---

# binbin-contentfly-showcase：内容展示页生成器

将一篇文章自动转换为双栏 HTML 展示页面，方便创作者对着口播稿录制视频，同时左侧视觉展示辅助观众理解。

## 核心功能

1. **输入**：一篇文章（Markdown 格式，包含 frontmatter 和正文）
2. **处理**：
   - 提取文章结构（标题、段落、重点、数据等）
   - 左侧生成给观众看的视觉展示页（根据口播内容转译为清晰、详细、可阅读的画面文案）
   - 右侧严格还原原始口播文稿（给创作者念，不改写、不扩写、不删减）
3. **输出**：一个完整的 HTML 文件

## 页面特点

- **双栏布局**：左侧 45% 视觉展示，右侧 55% 口播文稿
- **米白色背景**：`#faf8f5`
- **粉红色强调**：`#e94560`
- **独立滚动**：左右两侧可分别上下滚动
- **顶部留白**：180px 留白空间
- **视觉元素**：
  - 数据对比卡片
  - 金句高亮框
  - 步骤卡片
  - 流程图
  - 时间线

## 核心硬规则（必须遵守）

### 规则 1：右侧必须严格等于原始口播稿

右侧是创作者念稿区，不是改写区。

- 必须逐段保留 Markdown 正文中的口播原文。
- 必须保留原文中的情绪/节奏标记，例如 `[平静，直接进入]`、`[停顿 0.5秒]`、`[CTA]`。
- 必须保留原文中的 CTA、收尾、数据、用词和句序。
- 可以做的只有 HTML 包装：分节、段落 `<p>`、粗体 `<strong>`、少量颜色强调。
- 不允许重写、扩写、润色、概括、删减右侧文稿。
- 如果用户要求“不需要 CTA”或“开头不要大数字”，除非用户明确要求修改右侧原文，否则这些要求默认只作用于左侧展示页。

### 规则 2：左侧是给观众看的展示页，不是给创作者看的提示板

左侧文案必须像观众正在看的内容页，而不是创作者工作台。

- 不要出现幕后标记词：`开头信任锚点`、`核心金句`、`CTA`、`脚本结构`、`拍摄提示`、`案例锚点`、`诊断优化`、`节奏提示`、`口播文稿`。
- 不要使用“这里要”“这一段用于”“先建立可信度”这类创作者提示语。
- 模块标题要面向观众，例如：`收藏越多，越不会写`、`普通对标为什么没用`、`把爆款榨干的 3 步`。
- 左侧可以提炼和转译原文，但必须服务观众理解，不暴露制作逻辑。

### 规则 3：左侧开头不要用大数字压屏

左侧展示页的第一屏要先建立问题和冲突，不要一上来放大数字卡片。

- 不要在左侧第一屏直接放 `19 篇`、`8 万字`、`42 条` 这类数据卡片。
- 第一屏优先用普世痛点、反差、问题句或观点句。
- 大数字可以放在左侧中后段，作为案例证据或系统结果，不作为开头主视觉。

### 规则 4：左侧文字要比普通卡片更详细

左侧不是纯关键词海报，要能让观众看懂逻辑。

- 每个模块至少有 2-3 句完整说明，不要只堆短词。
- 步骤卡片的说明要能独立读懂：说明“为什么做这一步”和“这一步解决什么问题”。
- 对比卡片不能只写名词，要写清楚差异和后果。
- 金句框可以保留，但不能替代正文解释。

## 使用流程

### Step 1: 接收用户输入

用户可能提供：
- 文件路径：`生成展示页 02-内容管理/01-待深化的选题/文章.md`
- 当前编辑的文章：用户正在查看的文章
- 选中的文字：编辑器中选中的内容

### Step 2: 读取并解析文章

**必须读取的文件**：
1. 用户指定的 Markdown 文件

**解析内容**：
- Frontmatter（标题、日期、标签等元数据）
- 正文结构（标题层级、段落、列表、强调内容）
- 关键数据（数字、对比、时间等）
- 金句/核心观点

### Step 3: 生成 HTML 结构

**左侧视觉展示（45%）**：
```
- 主标题（大标题，带底部边框）
- 第一屏问题/冲突（不要用大数字开头）
- 内容模块（根据口播原文转译为观众可读文案）
  - 面向观众的标题 + 2-3 句详细说明
  - 步骤卡片（如果原文包含步骤/方法）
  - 对比卡片（如果原文有“普通做法 vs 系统做法”）
  - 数据卡片（放在中后段作为证据，不放第一屏）
  - 流程图（如果有步骤流程）
  - 时间线（如果有经历/故事）
- 结尾观点或自然收束
```

**右侧口播文稿（55%）**：
```
- 文稿标题栏
- 原始口播文字（严格保留）
  - 可按原文自然段或节奏标记分节
  - 原文中的 `[停顿]`、`[CTA]` 等标记必须保留
  - 可用 HTML 标签呈现原文粗体和少量强调
  - 不新增原文没有的提示框、讲解、总结或作者信息
```

### Step 4: 应用样式

**CSS 配色方案**：
```css
/* 背景 */
--bg-primary: #faf8f5;    /* 米白色 - 左侧背景 */
--bg-secondary: #fff;      /* 白色 - 右侧背景 */

/* 文字 */
--text-primary: #1a1a1a;   /* 深黑 - 标题 */
--text-secondary: #333;    /* 深灰 - 正文 */
--text-tertiary: #555;     /* 中灰 - 辅助文字 */

/* 强调 */
--accent-primary: #e94560; /* 粉红色 - 强调、标签 */
--accent-secondary: #667eea; /* 蓝紫色 - 提示框 */

/* 边框 */
--border-light: #e8e4df;   /* 浅灰米色 - 分割线 */
```

**布局样式**：
- 容器：`display: flex`, `height: 100vh`, `overflow: hidden`
- 左侧：`width: 45%`, `overflow-y: auto`, `padding: 180px 30px 40px`
- 右侧：`width: 55%`, `overflow-y: auto`, `padding: 180px 30px 40px`
- 顶部留白：180px

### Step 5: 输出文件

**保存位置**：与原文件同级目录
**文件名**：`[原文件名]-展示页.html`

**输出后告知用户**：
- 文件保存路径
- 使用方法（打开HTML，左右独立滚动，对着右侧念）

## 生成规则

### 左侧视觉展示生成规则

1. **主标题**：提取文章主标题，大字号显示
2. **第一屏**：先展示痛点/冲突/观点，不要用大数字开头
3. **内容分节**：根据口播原文的逻辑分节，生成观众可读的模块
4. **详细解释**：每个模块至少 2-3 句完整说明，避免只写关键词
5. **步骤卡片**：如果文章包含步骤/方法，生成卡片式展示，并说明每一步解决什么问题
6. **对比卡片**：如果有“普通做法 vs 系统做法”，用对比卡展示差异和后果
7. **数据卡片**：识别数字、结果、对比，放在中后段作为证据
8. **金句高亮**：识别粗体/强调内容，生成高亮框，但必须配合解释文字
9. **禁止幕后词**：左侧不要出现 `开头信任锚点`、`核心金句`、`CTA`、`口播文稿`、`拍摄提示` 等创作者视角词

### 右侧口播文稿生成规则

1. **严格保留原文**：右侧内容必须来自 Markdown 正文原文，不允许重写或扩写。
2. **保留节奏标记**：原文中的 `[平静]`、`[停顿]`、`[CTA]`、`[收尾]` 等标记必须出现。
3. **保留 CTA**：如果原文有 CTA，右侧必须保留；除非用户明确要求修改口播原文。
4. **可做 HTML 包装**：
   - 原文粗体：转换为 `<strong>`
   - 少量数据/关键词：可加 `<span class="script-emphasis">`
   - 原文段落：转换为 `<p>`
5. **禁止新增内容**：不要新增原文没有的解释、提示框、总结、作者信息、标题建议。

## HTML 模板结构

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[文章标题]</title>
    <style>
        /* CSS 样式 - 见下方完整样式 */
    </style>
</head>
<body>
    <div class="container">
        <!-- 左侧：视觉展示 -->
        <div class="visual-side">
            <h1 class="main-title">[文章标题]</h1>

            <!-- 内容模块 -->
            <div class="section">
                <div class="section-title">[节标题]</div>
                <div class="section-content">[内容]</div>
            </div>

            <!-- 观众视角内容模块：步骤卡片、对比卡、数据证据、观点高亮等 -->
        </div>

        <!-- 右侧：口播文稿 -->
        <div class="script-side">
            <div class="script-header">
                <div class="script-title">口播文稿</div>
                <div class="script-subtitle">严格保留原始口播稿，对着念即可录制</div>
            </div>

            <!-- 口播分节：必须来自原文，不得改写 -->
            <div class="script-section">
                <span class="script-label">[节标签]</span>
                <div class="script-text">[原文口播文字]</div>
            </div>
        </div>
    </div>
</body>
</html>
```

## 完整 CSS 样式参考

```css
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC',
                 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
    background: #f5f5f5;
    color: #333;
    line-height: 1.6;
}

.container {
    display: flex;
    max-width: 1200px;
    margin: 0 auto;
    background: #fff;
    height: 100vh;
    overflow: hidden;
}

/* 左侧视觉展示 */
.visual-side {
    width: 45%;
    background: #faf8f5;
    color: #333;
    padding: 180px 30px 40px;
    height: 100vh;
    overflow-y: auto;
    overflow-x: hidden;
}

.main-title {
    font-size: 26px;
    font-weight: 700;
    color: #1a1a1a;
    line-height: 1.5;
    margin-bottom: 50px;
    padding-bottom: 30px;
    border-bottom: 3px solid #e94560;
}

.section {
    margin-bottom: 35px;
    padding-bottom: 30px;
    border-bottom: 1px solid #e8e4df;
}

.section-title {
    font-size: 17px;
    font-weight: 700;
    margin-bottom: 18px;
    color: #1a1a1a;
    display: flex;
    align-items: center;
    gap: 10px;
}

.section-title::before {
    content: '';
    width: 4px;
    height: 18px;
    background: #e94560;
    border-radius: 2px;
}

/* 数据卡片、金句框、步骤卡片等样式 */
/* ... 详见参考文件 ... */

/* 右侧口播文稿 */
.script-side {
    width: 55%;
    background: #fff;
    padding: 180px 30px 40px;
    height: 100vh;
    overflow-y: auto;
    overflow-x: hidden;
}

.script-header {
    margin-bottom: 35px;
    padding-bottom: 25px;
    border-bottom: 2px solid #e94560;
}

.script-label {
    display: inline-block;
    background: #e94560;
    color: #fff;
    padding: 3px 10px;
    border-radius: 4px;
    font-size: 11px;
    margin-bottom: 10px;
    font-weight: 500;
}

.script-emphasis {
    color: #e94560;
    font-weight: 600;
}

.script-highlight {
    background: #fff3cd;
    padding: 1px 4px;
    border-radius: 3px;
    font-weight: 500;
}
```

## 使用示例

**用户输入**：
> 生成展示页 02-内容管理/01-待深化的选题/2026-04-13-抄了三个月爆款模板都没火-v2.1-最终版.md

**Skill 执行**：
1. 读取指定 Markdown 文件
2. 解析文章结构和关键信息
3. 生成双栏 HTML 展示页
4. 保存为 `2026-04-13-抄了三个月爆款模板都没火-v2.1-最终版-展示页.html`

**输出告知**：
```
✅ 展示页已生成

文件路径：02-内容管理/01-待深化的选题/2026-04-13-抄了三个月爆款模板都没火-v2.1-最终版-展示页.html

使用方法：
1. 用浏览器打开 HTML 文件
2. 左侧视觉展示可独立滚动
3. 右侧口播文稿可独立滚动
4. 对着右侧文字念即可录制视频
```

## 注意事项

1. **文章质量**：输入文章需要有清晰的结构（标题、段落、重点）
2. **右侧原文优先**：右侧必须严格还原口播稿，不能因为“优化展示页”而改写口播。
3. **左侧观众视角**：左侧所有标题和文字都要给观众看，不能出现创作者提示语。
4. **数据识别**：自动识别数字、百分比、对比等数据生成卡片，但不要放在左侧开头第一屏。
5. **金句提取**：识别粗体、强调内容作为金句高亮，但不要把模块命名为“核心金句”。
6. **口播包装**：右侧只做 HTML 包装和轻量强调，不做文案优化。

---

**所属仓库**：binbin-contentfly（彬彬内容飞轮）
**版本**：v2.0
**创建日期**：2026-04-13
**更新日期**：2026-08-23
