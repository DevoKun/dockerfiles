#!/bin/bash


export VERSION="0.4.6"
export TARBALL="etcd-v${VERSION}-linux-amd64.tar.gz"
export     DEB="etcd_${VERSION}_amd64.deb"


cat << EOF > build_etcd.sh

apt-get update
apt-get install -y wget ruby-dev gcc make
gem install fpm

export VERSION="$VERSION"
export TARBALL="$TARBALL"
export     DEB="$DEB"

wget https://github.com/coreos/etcd/releases/download/v\${VERSION}/\${TARBALL}

tar zxf \${TARBALL}
cd etcd-v0.4.6-linux-amd64

fpm -s dir -t deb -v \${VERSION} -n etcd -a amd64 \\
  --prefix=/usr/bin/ \\
  --url "https://github.com/coreos/etcd" \\
  --description "A highly-available key value store for shared configuration and service discovery" \\
  --deb-user root --deb-group root \\
  etcd etcdctl

mv \${DEB} /usr/src
du -h /usr/src/\${DEB}
cd /usr/src ; md5sum \${DEB} | tee \${DEB}.MD5SUM


EOF

touch $DEV
touch $DEV.MD5SUM
docker run -ti -v $(pwd)/build_etcd.sh:/usr/src/build_etcd.sh \
  -v $(pwd)/${DEB}.MD5SUM:/usr/src/${DEB}.MD5SUM \
  -v $(pwd)/${DEB}:/usr/src/${DEB} \
  ubuntu:14.04.1 \
  /bin/bash -c 'chmod +x /usr/src/build_etcd.sh ; cd /usr/src ; /usr/src/build_etcd.sh'
md5sum -c ${DEB}.MD5SUM




