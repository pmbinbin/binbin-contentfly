# binbin-contentfly

彬彬内容飞轮 Skill 仓库。目前包含从 brief 创作短视频、成稿精修、完整发布、发布文案、视频发布风险检查、视频转公众号文章、双栏 HTML 展示页、自媒体封面和评论区生成等十个 Skill。

## 作者

- 作者：彬彬
- 微信：`binbinpm`

## Skills

| Skill | 中文名称 | 用途 |
|---|---|---|
| `binbin-contentfly` | 彬彬内容飞轮 | 判断需求并路由到对应能力 |
| `binbin-contentfly-create-pipeline` | 彬彬短视频创作工作流 | 根据 brief、对标和个人风格，分阶段完成选题、大纲、逐字稿与拍摄脚本 |
| `binbin-contentfly-polish-pipeline` | 彬彬内容精修工作流 | 完整诊断和精修已有口播稿 |
| `binbin-contentfly-publish-pipeline` | 彬彬内容发布工作流 | 分步生成封面标题、两版文字标题、发布文案和封面 |
| `binbin-contentfly-publish-copy` | 彬彬发布文案 | 根据文章起草，先做发布风险检查，再生成人味文案 |
| `binbin-contentfly-risk-check` | 彬彬视频发布风险检查 | 结合通用语义审核与彬彬内部规范进行发布前排雷 |
| `binbin-contentfly-wechat-article` | 彬彬公众号文章 | 把视频逐字稿转成带配图、视频和表格规划的公众号 Markdown，并在素材补齐后排版 |
| `binbin-contentfly-showcase` | 彬彬内容展示页 | 将 Markdown 转成双栏 HTML 展示页 |
| `binbin-contentfly-cover` | 彬彬自媒体封面制作 | 制作视频号、抖音、小红书及 B 站封面 |
| `binbin-contentfly-comments` | 彬彬评论区生成 | 根据视频逐字稿生成自然评论及彬彬的对应作者回复 |

## 安装

发布到 GitHub 后，先确认安装工具可以发现仓库中的全部 Skill：

```bash
npx -y skills add pmbinbin/binbin-contentfly --list
```

正常应列出以下 10 个英文标识：

- `binbin-contentfly`
- `binbin-contentfly-create-pipeline`
- `binbin-contentfly-polish-pipeline`
- `binbin-contentfly-publish-pipeline`
- `binbin-contentfly-publish-copy`
- `binbin-contentfly-risk-check`
- `binbin-contentfly-wechat-article`
- `binbin-contentfly-showcase`
- `binbin-contentfly-cover`
- `binbin-contentfly-comments`

然后安装整个仓库：

```bash
npx -y skills add pmbinbin/binbin-contentfly -g --all
```

当前 `skills` CLI 需要 Node.js 22.20.0 或更高版本。安装完成后，在 Codex 的下一轮任务或重启客户端后刷新 Skill 列表。Codex 会优先读取各 Skill 的 `agents/openai.yaml`：界面显示中文名，调用标识保持 `binbin-contentfly-*` 英文系列名；不支持该字段的其他 Agent 客户端可能只显示英文标识。

精修工作流会在运行前检查 dbskill 和 renwei-writing。完整发布工作流会分阶段调用 `dbs-xhs-title`、`binbin-contentfly-publish-copy` 和 `binbin-contentfly-cover`，每阶段等待用户确认。发布文案工作流会先调用 `binbin-contentfly-risk-check`，再调用 `renwei-writing`；公众号文章工作流会用 `khazix-writer` 校准真人感，并在素材补齐后调用 `gzh-design` 完成公众号排版。公众号文章工作流首次运行会检查这两个依赖，缺失时只从用户指定的 `KKKKhazix/khazix-skills` 与 `isjiamu/gzh-design-skill` 自动安装，再复检；已安装时不覆盖。风险检查已内置彬彬视频违禁词规范，但通用语义风险检查仍由 dbskill 中的 `dbs-content-risk-check` 提供。其他第三方依赖不会随本仓库打包，也不会未经用户同意自动安装。

封面 Skill 首次运行时会询问本机人像素材目录，并把路径写入不纳入 Git 的 `config.local.json`。仓库不会包含作者电脑上的绝对路径。

## 使用许可

个人使用、学习、研究与非商业项目可以直接使用。商业用途需要单独授权，请联系作者。

完整条款见 [LICENSE](LICENSE)。本仓库使用的是带商业用途限制的自定义许可，不属于 OSI 认证的开源许可证。
