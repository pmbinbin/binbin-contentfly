---
name: binbin-contentfly
description: |
  彬彬内容飞轮主路由。识别用户是要从 brief 和对标开始创作短视频、完整精修已有口播稿、分步完成标题发布文案和封面、单独生成发布文案、检查视频发布风险、把视频逐字稿转成公众号文章、把 Markdown 生成双栏 HTML 展示页，还是制作自媒体封面，并调用对应的 binbin-contentfly 系列 Skill。用于用户调用 /binbin-contentfly、/彬彬内容飞轮，或只说“帮我处理这篇内容”但尚未指定具体工作流时。
---

# 彬彬内容飞轮

只负责识别需求和路由，不在主路由里重复执行子 Skill 的工作。

## 路由表

| 用户意图 | 调用 Skill | 说明 |
|---|---|---|
| 提供品牌 brief、对标稿或项目文件夹，希望从零完成选题、大纲、逐字稿和拍摄脚本 | `binbin-contentfly-create-pipeline` | 按阶段创作，每阶段等待确认；默认输出 Markdown，并使用彬彬个人创作风格与已验证模板 |
| 已有完整口播稿，希望诊断、改开头、理逻辑、调语气、出标题 | `binbin-contentfly-polish-pipeline` | 执行完整内容精修工作流 |
| 已有最终逐字稿，希望分步完成封面标题、两版文字标题、发布文案和封面 | `binbin-contentfly-publish-pipeline` | 每阶段等待确认，最后调用封面 Skill 生成图片 |
| 希望根据文章或逐字稿写作品发布标题、短正文与话题标签 | `binbin-contentfly-publish-copy` | 使用固定发布结构，先做发布风险检查，再调用 `renwei-writing` 做人味校准 |
| 只想检查违禁词、敏感表达、商单风险或发布前排雷 | `binbin-contentfly-risk-check` | 调用通用语义审核，并叠加彬彬内部发稿规范 |
| 希望把已发布视频或最终逐字稿转换成公众号文章，并规划配图、视频和表格 | `binbin-contentfly-wechat-article` | 先生成带素材要求的 Markdown，素材补齐后调用 `gzh-design` 排成公众号 HTML |
| 希望把 Markdown 转成双栏 HTML、展示页或对稿页面 | `binbin-contentfly-showcase` | 生成内容展示页 |
| 希望先精修，再生成展示页 | `binbin-contentfly-polish-pipeline` | 把“生成 HTML”要求一并传入，由精修工作流最后调用 Showcase |
| 希望根据主题、标题、脚本或参考图制作视频号、抖音、小红书、B站封面 | `binbin-contentfly-cover` | 生成并确认提示词后制作自媒体封面 |
| 提供逐字稿，希望生成30条自然评论及其作者回复，或继续生成下一批 | `binbin-contentfly-comments` | 用于评论展示栏、Demo、样机和内容预演，输出评论列表及彬彬的逐条回复 |

## 路由流程

1. 从用户原话判断意图。
2. 意图明确时，直接读取并执行对应 Skill，不重复提问。
3. 意图不明确时，只问一个问题：

   > 你现在是要从 brief 和对标开始创作、精修已有成稿、走完整发布工作流、单独写发布文案、检查发布风险、把视频转成公众号文章、生成 HTML 展示页、制作封面，还是根据逐字稿生成评论区评论和作者回复？

4. 用户回答后立即执行对应 Skill 的完整流程。

## 子 Skill 位置

优先读取同仓库的相对路径：

- `../binbin-contentfly-polish-pipeline/SKILL.md`
- `../binbin-contentfly-create-pipeline/SKILL.md`
- `../binbin-contentfly-publish-pipeline/SKILL.md`
- `../binbin-contentfly-publish-copy/SKILL.md`
- `../binbin-contentfly-risk-check/SKILL.md`
- `../binbin-contentfly-wechat-article/SKILL.md`
- `../binbin-contentfly-showcase/SKILL.md`
- `../binbin-contentfly-cover/SKILL.md`
- `../binbin-contentfly-comments/SKILL.md`

如果相对路径不存在，再在标准 Skill 安装目录中按 Skill 名查找。

## 边界

- 同一条请求同时包含精修和 HTML 时，不拆成两轮，交给精修工作流串联完成。
- 同一条请求同时包含“逐字稿转公众号文章”和“排版发布”时，交给 `binbin-contentfly-wechat-article` 串联 Markdown、素材门禁和 `gzh-design`，不要误路由到双栏展示页。
- 不把已经废弃的旧 `contentfly-*` Skill 推荐给用户。
- 当前能力包括从 brief 与对标开始的短视频创作、内容精修、完整发布工作流、发布文案、视频发布风险检查、视频转公众号文章、展示页、自媒体封面制作和评论区合成文案生成；超出范围时如实说明，不虚构不存在的子 Skill。
- 用户用中文时，用中文回复。
