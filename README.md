# OpenToggl

OpenToggl 自托管时间追踪服务。

**线上地址**: [tolist.ccwu.cc](https://tolist.ccwu.cc)

## 项目结构

```
.
├── docker-compose.yml    # Docker Compose 编排文件
├── .env.example          # 环境变量模板
├── .env                  # 实际环境变量（不提交到 Git）
└── ship.sh               # 一键提交 + 部署脚本
```

## 技术栈

| 服务 | 镜像 | 端口 |
|------|------|------|
| OpenToggl | `correctroad/opentoggl:latest` | 8080 |
| PostgreSQL | `postgres:17-alpine` | 5432 (内部) |
| Redis | `redis:8-alpine` | 6379 (内部) |

## 快速开始

```bash
# 复制环境变量
cp .env.example .env

# 启动
docker compose up -d

# 访问 http://localhost:8080
```

## 部署

```bash
./ship.sh "提交信息"
```

相当于：

```bash
git add -A
git commit -m "改动说明"
git push origin main
docker compose pull     # 拉取最新镜像
docker compose up -d    # 重启服务
```

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `OPENTOGGL_PORT` | `8080` | 对外端口 |
| `OPENTOGGL_POSTGRES_PASSWORD` | `postgres` | 数据库密码 |
| `OPENTOGGL_REDIS_PASSWORD` | `opentoggl` | Redis 密码 |

生产环境务必修改两个密码。

## 公网访问（Cloudflare Tunnel）

本项目通过 Cloudflare Tunnel 将本地 `localhost:8080` 暴露到公网 `tolist.ccwu.cc`。

Tunnel 配置文件：

```
tunnel: <tunnel-id>
credentials-file: /Users/pengshz/.cloudflared/<tunnel-id>.json

ingress:
  - hostname: tolist.ccwu.cc
    service: http://localhost:8080
  - service: http_status:404
```

### 管理 Tunnel

```bash
# 查看状态
cloudflared tunnel info tolist

# 重启
launchctl unload ~/Library/LaunchAgents/com.tolist.cloudflared.plist
launchctl load ~/Library/LaunchAgents/com.tolist.cloudflared.plist
```

## 升级

```bash
docker compose pull
docker compose up -d
```

## 同步更新机制

当 GitHub 仓库代码更新后：

```bash
./ship.sh "你的提交信息"
```

这会自动完成：git add → commit → push → 拉取最新镜像 → 重启服务，`tolist.ccwu.cc` 即刻更新。
