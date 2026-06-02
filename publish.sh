#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "用法：./publish.sh \"本次更新说明\""
  echo "示例：./publish.sh \"添加作者信息\""
  exit 1
fi

MESSAGE="$*"

cd "$(dirname "$0")"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "当前目录还不是 Git 仓库，请先完成 git init 和远程仓库绑定。"
  exit 1
fi

if [ -z "$(git status --porcelain)" ]; then
  echo "没有检测到需要发布的改动。"
  exit 0
fi

echo "准备发布：$MESSAGE"
git add .
git commit -m "$MESSAGE"
git push
echo "发布完成。GitHub Pages 通常会在 1-3 分钟后更新。"

