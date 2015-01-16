
apt-get update
apt-get install -y wget ruby-dev gcc make
gem install fpm

export VERSION="0.4.6"
export TARBALL="etcd-v0.4.6-linux-amd64.tar.gz"
export     DEB="etcd_0.4.6_amd64.deb"

wget https://github.com/coreos/etcd/releases/download/v${VERSION}/${TARBALL}

tar zxf ${TARBALL}
cd etcd-v0.4.6-linux-amd64

fpm -s dir -t deb -v ${VERSION} -n etcd -a amd64 \
  --prefix=/usr/bin/ \
  --url "https://github.com/coreos/etcd" \
  --description "A highly-available key value store for shared configuration and service discovery" \
  --deb-user root --deb-group root \
  etcd etcdctl

mv ${DEB} /usr/src
du -h /usr/src/${DEB}
cd /usr/src ; md5sum ${DEB} | tee ${DEB}.MD5SUM


