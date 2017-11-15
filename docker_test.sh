#!/bin/sh

PROJECT_NAME="cli-tool"
PLATFORM_NAME="centos7"
BIN_NAME=${PROJECT_NAME}
DOCKER_IMAGE_NAME="${PROJECT_NAME}/${PLATFORM_NAME}"
DOCKER_HOME_DIR="./docker/test"
DOCKER_CACHE_DIR="${HOME}/docker"
DOCKER_CACHE_IMAGE_PATH="${DOCKER_CACHE_DIR}/${PLATFORM_NAME}.tar"

# 既にイメージを起動していたら停止する
if sudo docker ps -a | grep "${DOCKER_IMAGE_NAME}" > /dev/null 2>&1; then
  sudo docker ps -a | grep "${DOCKER_IMAGE_NAME}" | awk  '{print $1}' | xargs sudo docker rm -f > /dev/null
fi

# 既にイメージをキャッシュしていたらそれを利用する
if file ${DOCKER_CACHE_IMAGE_PATH} | grep empty; then
  sudo docker load --input ${DOCKER_CACHE_IMAGE_PATH}
fi

# 実行ファイルをDockerコンテナ内にコピーして実行
cp "${BIN_NAME}" "${DOCKER_HOME_DIR}/${BIN_NAME}"

sudo docker build -t "${DOCKER_IMAGE_NAME}" "${DOCKER_HOME_DIR}"
mkdir -p ${DOCKER_CACHE_DIR}
sudo docker save "${DOCKER_IMAGE_NAME}" > ${DOCKER_CACHE_IMAGE_PATH}
sudo docker run -d "${DOCKER_IMAGE_NAME}"

cid=`sudo docker ps -a | grep "${DOCKER_IMAGE_NAME}" | awk  '{print $1}'`
sudo docker logs ${cid}

rm -f "${DOCKER_HOME_DIR}/${BIN_NAME}"
