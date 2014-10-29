SAIO - Swift All In One
=======================

## Client Authentication
### Swift can use its internal authentication system, TempAuth, or an OpenStack Keystone server. 
* For the stand-alone Swift server we will keep it simple and use **TempAuth**.
* TempAuth usernames and passwords are configured in **proxy-server.conf**
* The TempAuth users are configured in this format:
```raw
user_<tenant>_<username> = <password> <privileges> 
```

### Swift Privileges
#### .admin group
* Can create, delete, and modify any container or object in the tenant account: **user_tenant_* **

#### .reseller_admin group
* cluster-level super-user
* Can do anything to any object or container in the entire system.
* Can revoke and grant permissions for any existing non-admin user. 
* Full access to anything in the Swift cluster.
* Privileges granted by .reseller_admin are a superset of those granted by .admin.
* Putting a user in both .reseller_admin and .admin groups does not accomplish anything over putting them only in .reseller_admin.

#### Reference
* https://swiftstack.com/blog/2012/01/04/swift-tempauth/


### Using the python swift client to access Swift
#### Simple Access Test
```bash
swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing stat
```

#### Upload a File
```bash
swift -A http://127.0.0.1:49182/auth/v1.0 -U test:tester -K testing upload swift swift.txt
```




## Swift Hashes
* The prefix and suffix values are used as salts when generating the hashes for the ring mappings.
* The random unique strings can never change!
* Generate the strings using **od**:
```bash
od -t x8 -N 8 -A n </dev/random
```
* Set the keys in **swift.conf**:
```ini
[swift-hash]
swift_hash_path_prefix = f4773609735ce702
swift_hash_path_suffix = 5fc83be6d952b4ad
```

## Enable Object Versioning in a Swift Cluster
* Set allow_versions to True in the container server config.
* **FILE:** container-server.conf:
```ini
[app:container-server]
allow_versions = true
```

### Reference
* http://docs.openstack.org/developer/swift/overview_object_versioning.html
* https://github.com/openstack/swift/blob/master/etc/container-server.conf-sample

## Filesystem Extended Attributes (xattr)
* Swift requires xattr.
* To use xattr, be sure Docker is backed by XFS, btrfs, or ext4 with user_xattr or something that supports xattr.
* According to [Wikipedia](https://en.wikipedia.org/wiki/Extended_file_attributes#Linux) ext2, ext3, ext4, JFS, Squashfs, ReiserFS, XFS, Btrfs, Lustre, and OCFS2 all support xattr.

## Swift Service(s)
* **openstack-swift-proxy**
* **openstack-swift-object**
* **openstack-swift-object-replicator**
* **openstack-swift-object-updater**
* **openstack-swift-object-auditor**
* **openstack-swift-container**
* **openstack-swift-container-replicator**
* **openstack-swift-container-updater**
* **openstack-swift-container-auditor**
* **openstack-swift-account**
* **openstack-swift-account-replicator**
* **openstack-swift-account-reaper**
* **openstack-swift-account-auditor**


* **xinetd**: Used to start rsyncd
* **memcached**

## RsyncD
* Used to transfer files between swift nodes
* Started by xinetd.
* Enabled by configuring /etc/xinetd.d/rsync

## Notes
* [Install from source repos](http://docs.openstack.org/developer/swift/development_saio.html)
* [Install via RDO](http://thornelabs.net/2014/07/14/install-a-stand-alone-multi-node-openstack-swift-cluster-with-virtualbox-or-vmware-fusion-and-vagrant.html)
* [Dockerfile to create an OpenStack Swift installation with only one replica from ccollicut](https://github.com/ccollicutt/docker-swift-onlyone)

### The partition used to store Swift data
* Should be a high-performance partition.
* Swift is meant to be filesystem agnostic, but has been significantly tested with XFS, so use XFS:
```raw
/dev/sdb1 /mnt/sdb1 xfs noatime,nodiratime,nobarrier,logbufs=8 0 0
```

### Ubuntu 12.04 LTS (Precise Pangolin)
```bash
sudo apt-get install swift swauth swift-account swift-container swift-object swift-proxy
```

### Using a Loopback device for the storage filesystem
```bash
dd if=/dev/zero of=/mnt/object-volume1 bs=1 count=0 seek=10G
losetup /dev/loop2 /mnt/object-volume1

mkfs.xfs -i size=1024 /dev/loop2
echo "/dev/loop2 /srv/node/loop2 xfs noatime,nodiratime,nobarrier,logbufs=8 0 0" >> /etc/fstab
mount -a
```


## Troubleshooting

### /lib64/libselinux.so.1: invalid ELF header
* When building the docker container I received an error message about an invalid elf header when trying to run yum.
```bash
docker build -t local:swift .
```


```raw
There was a problem importing one of the Python modules
required to run yum. The error leading to this problem was:

   /lib64/libselinux.so.1: invalid ELF header

Please install a package which provides this module, or
verify that the module is installed correctly.

It's possible that the above module doesn't match the
current version of Python, which is:
2.6.6 (r266:84292, Jan 22 2014, 09:42:36) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-4)]

If you cannot solve this problem yourself, please go to 
the yum faq at:
  http://yum.baseurl.org/wiki/Faq
```

* At first I figured an invalid version of python was getting installed, however when I started the container and went straight in to bash everything was throwing the error.
* I rebuilt the container without using the cache.

```bash
sudo docker build --no-cache=true --rm=true -t local:swift .

```

* The broken libselinux.so.1 was being installed as a dependency for puppet and supervisor from EPEL.

```raw
================================================================================
 Package                 Arch          Version                Repository   Size
================================================================================
Installing:
 puppet                  noarch        2.7.25-2.el6           epel        1.1 M
 supervisor              noarch        2.1-8.el6              epel        292 k
Installing for dependencies:
 augeas-libs             x86_64        1.0.0-7.el6            base        313 k
 compat-readline5        x86_64        5.2-17.1.el6           base        130 k
 dmidecode               x86_64        1:2.12-5.el6_5         base         73 k
 facter                  x86_64        1.6.18-3.el6           epel         62 k
 libselinux-ruby         x86_64        2.0.94-5.8.el6         base        100 k
 pciutils                x86_64        3.1.10-4.el6           base         85 k
 pciutils-libs           x86_64        3.1.10-4.el6           base         34 k
 python-meld3            x86_64        0.6.7-1.el6            epel         71 k
 ruby                    x86_64        1.8.7.374-2.el6        base        538 k
 ruby-augeas             x86_64        0.4.1-1.el6            epel         21 k
 ruby-libs               x86_64        1.8.7.374-2.el6        base        1.7 M
 ruby-shadow             x86_64        1.4.1-13.el6           epel         11 k
 virt-what               x86_64        1.11-1.2.el6           base         24 k
 which                   x86_64        2.19-6.el6             base         38 k
Updating for dependencies:
 libselinux              x86_64        2.0.94-5.8.el6         base        108 k
 libselinux-utils        x86_64        2.0.94-5.8.el6         base         82 k
```

* After rebuilding without the cache everything worked correctly.
* The base centos6 container comes with a **libselinux.repo**, which I figure needs to take priority over anything else that may get installed.
* To ensure **libselinux.repo** was given priority, I updated the Dockerfile to append the file with a `priority=1` statement.


### Error mounting: invalid argument
```raw
2014/10/28 16:49:08 Error mounting '/dev/mapper/docker-253:0-21080315-793fcfde9862696828a80395111f0d5e22f92918e099a7a3b406e35092db95c8-init' on '/var/lib/docker/devicemapper/mnt/793fcfde9862696828a80395111f0d5e22f92918e099a7a3b406e35092db95c8-init': invalid argument
```
* Covered in [Docker issue 4036](https://github.com/docker/docker/issues/4036)
* I was running Docker 0.9.1 ***(docker-io-0.9.1-1.fc19.x86_64)*** so I updated to the latest Docker, which for me was 1.1 ***(1.1.2-3.fc19***.

```bash
sudo yum update docker-io
```


### Unknown filesystem type on /dev/mapper/docker
* According to the Docker errors this is related to [Docker issue 4036](https://github.com/docker/docker/issues/4036) listed above.
* 
```bash
service docker stop
sudo rm -Rf /var/lib/docker
service docker start
```


### http://yum.theforeman.org/releases/1.5/%25FDIST%25%25RELEASEVER%25/x86_64/repodata/repomd.xml "The requested URL returned error: 404 Not Found"
```raw
http://yum.theforeman.org/releases/1.5/%25FDIST%25%25RELEASEVER%25/x86_64/repodata/repomd.xml: [Errno 14] PYCURL ERROR 22 - "The requested URL returned error: 404 Not Found"
Trying other mirror.
Error: Cannot retrieve repository metadata (repomd.xml) for repository: foreman. Please verify its path and try again
```
* ***Valid URL***: http://yum.theforeman.org/releases/1.5/el6/x86_64/

```bash
sed -i 's/%FDIST%%RELEASEVER%/el6/g' /etc/yum.repos.d/foreman.repo
```

### memcached exit status 67
* Trying to start memcache as a non-existent user. Doublecheck the username.
