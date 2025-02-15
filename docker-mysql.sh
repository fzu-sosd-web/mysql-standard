#!/bin/bash

# 默认值
MYSQL_CONTAINER_NAME="${MYSQL_CONTAINER_NAME:-default-mysql}"
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-woshisb}"
MYSQL_DATABASE="${MYSQL_DATABASE:-default}"
MYSQL_USER="${MYSQL_USER:-default}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-woshisb}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_DATA_DIR="${MYSQL_DATA_DIR:-$(pwd)/mysql_data}"

# 加载指定的环境变量文件
if [ -n "$1" ]; then
    if [ -f "$1" ]; then
        source "$1"
        echo "已加载环境变量文件：$1"
    else
        echo "环境变量文件不存在：$1"
        exit 1
    fi
fi

# 创建数据持久化目录
if [ ! -d "$MYSQL_DATA_DIR" ]; then
    mkdir -p "$MYSQL_DATA_DIR"
    echo "创建数据目录：$MYSQL_DATA_DIR"
fi

# 启动 MySQL 容器
sudo docker run -d \
    --name "$MYSQL_CONTAINER_NAME" \
    -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
    -e MYSQL_DATABASE="$MYSQL_DATABASE" \
    -e MYSQL_USER="$MYSQL_USER" \
    -e MYSQL_PASSWORD="$MYSQL_PASSWORD" \
    -p "$MYSQL_PORT":3306 \
    -v "$MYSQL_DATA_DIR":/var/lib/mysql \
    mysql:latest

# 检查容器是否启动成功
if [ $? -eq 0 ]; then
    echo "MySQL 容器启动成功："
    echo "  容器名：$MYSQL_CONTAINER_NAME"
    echo "  访问端口：$MYSQL_PORT"
    echo "  数据目录：$MYSQL_DATA_DIR"
else
    echo "MySQL 容器启动失败，请检查 Docker 日志。"
    exit 1
fi
