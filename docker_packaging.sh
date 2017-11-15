#!/bin/sh

PROJECT_NAME="cli-tool"
PLATFORM_NAME="centos7"
BIN_NAME=${PROJECT_NAME}
SPEC_FILE="cli-tool.spec"
DOCKER_IMAGE_NAME="${PROJECT_NAME}/${PLATFORM_NAME}"
DOCKER_HOME_DIR="./docker/packaging"
DOCKER_PACKAGING_DIR="packaging"
DOCKER_CACHE_DIR="${HOME}/docker"
DOCKER_CACHE_IMAGE_PATH="${DOCKER_CACHE_DIR}/${PLATFORM_NAME}.tar"
GENERATED_RPM_PATH="/root/rpm/RPMS/x86_64/cli-tool-0.0.1-1.x86_64.rpm"

# 既にイメージを起動していたら停止する
if sudo docker ps -a | grep "${DOCKER_IMAGE_NAME}" > /dev/null 2>&1; then
  sudo docker ps -a | grep "${DOCKER_IMAGE_NAME}" | awk  '{print $1}' | xargs sudo docker rm -f > /dev/null
fi

# 実行ファイルのアーカイブ,specファイルをDockerコンテナ内にコピーして実行
mkdir -p "${DOCKER_PACKAGING_DIR}"
cp "${BIN_NAME}" "${DOCKER_PACKAGING_DIR}/${BIN_NAME}"
tar cvzf "${DOCKER_HOME_DIR}/${BIN_NAME}.tar.gz" "${DOCKER_PACKAGING_DIR}/${BIN_NAME}"
cp "${SPEC_FILE}" "${DOCKER_HOME_DIR}/${SPEC_FILE}"

sudo docker build -t "${DOCKER_IMAGE_NAME}" ${DOCKER_HOME_DIR}
mkdir -p ${DOCKER_CACHE_DIR}
sudo docker save "${DOCKER_IMAGE_NAME}" > ${DOCKER_CACHE_IMAGE_PATH}
sudo docker run -d --privileged "${DOCKER_IMAGE_NAME}"

cid=`sudo docker ps -a | grep "${DOCKER_IMAGE_NAME}" | awk  '{print $1}'`
sudo docker logs ${cid}

# Dockerイメージ内でビルドされたRPMパッケージをローカルにコピー
sudo docker cp "${cid}:${GENERATED_RPM_PATH}" cli-tool.rpm

sudo rm -f "${DOCKER_HOME_DIR}/${BIN_NAME}.tar.gz"
sudo rm -f "${DOCKER_HOME_DIR}/${SPEC_FILE}"
