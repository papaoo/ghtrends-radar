# 本机运行说明

源码：noahbenjamin1994/ghtrends-radar，MIT 许可。安装时上游提交：`cbd9ad0fd4cf66aff67e0888a6e61aa369164882`。

你的 Fork：https://github.com/ding18363123855-stack/ghtrends-radar 。本机 origin 已指向该仓库，upstream 保留原作者地址。

- 入口：http://127.0.0.1:3721/?lang=zh
- 启动：在项目目录运行 `powershell -File scripts/start-local.ps1`
- 停止：`powershell -File scripts/stop-local.ps1`
- 重建：`npm ci`，然后 `npm run build`
- 数据：项目内 `data/ghtrends.sqlite`；日志与进程号：`.local/`。
- 本机服务只监听 127.0.0.1；关机后需要重新启动。

项目自带 8 份有来源日期的初始报告，首页显示并不代表已经重新采集全部数据。
安装后验证了健康接口、真实公开 GitHub 仓库查询、构建、类型检查以及上游 397 项测试。
依赖锁定文件已应用兼容安全更新，2026-10-13 的 npm audit 报告为 0 项漏洞。

## 模型与数据源

AI 研判需在本机 `.env` 中填写自己的 `DEEPSEEK_API_KEY`；可参考 `.env.example`。
重启后生效。模型调用可能产生所选供应商的费用，本次没有填写密钥或启用付费研究。
GitHub Token 可选；无 Token 使用公开 API 的未认证额度。Google Trends 可能限流或缺数据，页面应保留这些限制。
不要把 `.env`、SQLite、日志或私人研究结果加入 Git。

## 云端限制

原版依赖持久化 SQLite、单个长驻 Node.js 实例及后台任务，不能直接当成 Vercel 静态网站发布。
本次提供可用的本机完整服务。公开云端完整服务需要带持久化磁盘的 Node.js/Docker 主机，以及相应的访问控制。
自托管模式没有账户隔离，切勿直接将这个本机实例暴露到公网。

## CLI

```powershell
$env:GHTRENDS_DATA_DIR = Join-Path $PWD 'data'
node dist/cli.js repo facebook/react
node dist/cli.js scan --topic agent-memory
node dist/cli.js watch list
```

扫描是否完成取决于模型配置与数据源可用性；`watch run` 只执行一次刷新。
