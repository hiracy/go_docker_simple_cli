# Dockerhubから最新のCentOS7を利用する
FROM centos:7
ARG author="package-user"
ARG project_name="cli-tool"

# RPMパッケージ作成に必要なライブラリのインストール
RUN yum install -y yum install rpm-build yum-utils ncurses-devel glibc-devel gcc
RUN mkdir -p ~/rpm/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# RPMパッケージの各種パラメータ設定
RUN echo "%_topdir $HOME/rpm" > ~/.rpmmacros
RUN echo "%packager ${author}" >> ~/.rpmmacros

# specと実行ファイルをDockerコンテナ内にコピー
COPY ${project_name}.spec   /tmp/${project_name}.spec
COPY ${project_name}.tar.gz /tmp/${project_name}.tar.gz
RUN  cp /tmp/${project_name}.spec  ~/rpm/SPECS/${project_name}.spec
RUN  cp /tmp/${project_name}.tar.gz ~/rpm/SOURCES/${project_name}.tar.gz

# RPMパッケージ作成
RUN rpmbuild -bb ~/rpm/SPECS/${project_name}.spec
