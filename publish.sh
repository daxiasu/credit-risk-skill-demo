#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "用法：./publish.sh \"本次更新说明\" [版本号]"
  echo "示例：./publish.sh \"添加作者信息\""
  echo "示例：./publish.sh \"第一版可演示版本\" v0.4"
  exit 1
fi

MESSAGE="$1"
VERSION="${2:-}"

cd "$(dirname "$0")"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "当前目录还不是 Git 仓库，请先完成 git init 和远程仓库绑定。"
  exit 1
fi

if [ -z "$(git status --porcelain)" ]; then
  echo "没有检测到需要发布的改动。"
  exit 0
fi

if [ -n "$VERSION" ] && ! [[ "$VERSION" =~ ^v[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
  echo "版本号格式建议使用 v0.4 或 v1.0.0。当前输入：$VERSION"
  exit 1
fi

echo "准备发布：$MESSAGE"
git add .
git commit -m "$MESSAGE"
git push

if [ -n "$VERSION" ]; then
  if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo "版本 $VERSION 已存在，未重复创建 tag。"
  else
    git tag "$VERSION" -m "$MESSAGE"
    git push origin "$VERSION"
    echo "已创建并推送版本：$VERSION"
  fi
fi

echo "发布完成。GitHub Pages 通常会在 1-3 分钟后更新。"
