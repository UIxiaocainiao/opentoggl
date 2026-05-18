#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "用法: ./ship.sh \"提交信息\""
  exit 1
fi

git add -A
git commit -m "$1"
git push origin main

# 拉取最新镜像并重启
echo "正在拉取最新镜像..."
docker compose -f docker-compose.yml pull
echo "正在重启服务..."
docker compose -f docker-compose.yml up -d
echo "部署完成！访问 https://tolist.ccwu.cc"
