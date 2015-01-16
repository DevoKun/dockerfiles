
* https://github.com/solarkennedy/puppet-etcd


## Build .deb and .rpm for etcd
```bash

cat << EOF > build_etcd.sh

apt-get update
apt-get install -y wget ruby-dev gcc make
gem install fpm

export VERSION="0.4.6"
export TARBALL="etcd-v${VERSION}-linux-amd64.tar.gz"

wget https://github.com/coreos/etcd/releases/download/v${VERSION}/${TARBALL}

tar zxf ${TARBALL}2
cd etcd-v0.4.6-linux-amd64

fpm -s dir -t deb -v ${VERSION} -n etcd -a amd64 \
  --prefix=/usr/bin/ \
  --url "https://github.com/coreos/etcd" \
  --description "A highly-available key value store for shared configuration and service discovery" \
  --deb-user root --deb-group root \
  etcd etcdctl


EOF

docker run -ti ubuntu:14.04.1 -v $(pwd)/build_etcd.sh:/usr/src/build_etcd.sh \
  -v $(pwd)/files/etcd_0.4.6_amd64.deb:/usr/src/etcd_0.4.6_amd64.deb \
  /bin/bash -c 'chmod +x /usr/src/build_etcd.sh ; /usr/src/build_etcd.sh'

```

## files list file for package 'adduser' is missing final newline

* The container is corrupted. Redownload.


