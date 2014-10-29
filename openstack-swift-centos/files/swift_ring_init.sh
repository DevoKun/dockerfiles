#!/bin/bash

###
### Based on: https://github.com/ccollicutt/docker-swift-onlyone/blob/master/files/startmain.sh
###


echo
echo -e "\033[33;1m##########################################\033[37;0m"
echo -e "\033[33;1m#### Swift Ring Setup                 ####\033[37;0m"
echo -e "\033[33;1m##########################################\033[37;0m"
echo


# These can be set with docker run -e VARIABLE=X at runtime
SWIFT_PART_POWER=${SWIFT_PART_POWER:-7}
SWIFT_PART_HOURS=${SWIFT_PART_HOURS:-1}
SWIFT_REPLICAS=${SWIFT_REPLICAS:-1}

if [ -e /srv/account.builder ]; then
  echo
	echo -e "\033[37;1m  * \033[33;1m Ring files already exist in /srv, copying them to /etc/swift... \033[37;0m"
	cp /srv/*.builder /etc/swift/
	cp /srv/*.gz      /etc/swift/
fi

echo
echo -e "\033[37;1m  * \033[33;1m Reset perms on /srv \033[37;0m"
chown -R swift:swift /srv

echo
echo -e "\033[37;1m  * \033[33;1m Checking for pre-exisint ring files \033[37;0m"

if [ ! -e /etc/swift/account.builder ]; then

	cd /etc/swift

	# 2^& = 128 we are assuming just one drive
	# 1 replica only

  echo
	echo -e "\033[37;1m  * \033[33;1m No existing ring files, creating them... \033[37;0m"

  ### http://docs.openstack.org/developer/swift/admin_guide.html#scripting-ring-creation
  ### swift-ring-builder account.builder add z1-<account-server-1>:6002/sdb1 1
  ### swift-ring-builder account.builder add z2-<account-server-2>:6002/sdb1 1
  ###
  ### The “z1”, “z2”, etc. designate zones, and you can choose whether you put devices in the same or different zones.
  ###
  ### All account servers are assumed to be listening on port 6002,
  ### and have a storage device called “sdb1” (this is a directory name created under /drives when we setup the account server).
  
  echo
  echo -e "\033[37;1m    ** \033[33;1m object.builder \033[37;0m"
	swift-ring-builder object.builder create ${SWIFT_PART_POWER} ${SWIFT_REPLICAS} ${SWIFT_PART_HOURS} | awk '{ print "          "$0; }'
	swift-ring-builder object.builder add r1z1-127.0.0.1:6010/sdb1 1 | awk '{ print "          "$0; }'
	swift-ring-builder object.builder rebalance | awk '{ print "          "$0; }'
  
  echo
  echo -e "\033[37;1m    ** \033[33;1m container.builder \033[37;0m"
	swift-ring-builder container.builder create ${SWIFT_PART_POWER} ${SWIFT_REPLICAS} ${SWIFT_PART_HOURS} | awk '{ print "          "$0; }'
	swift-ring-builder container.builder add r1z1-127.0.0.1:6011/sdb1 1 | awk '{ print "          "$0; }'
	swift-ring-builder container.builder rebalance | awk '{ print "          "$0; }'
  
  echo
  echo -e "\033[37;1m  * \033[33;1m account.builder \033[37;0m"
	swift-ring-builder account.builder create ${SWIFT_PART_POWER} ${SWIFT_REPLICAS} ${SWIFT_PART_HOURS} | awk '{ print "          "$0; }'
	swift-ring-builder account.builder add r1z1-127.0.0.1:6012/sdb1 1 | awk '{ print "          "$0; }'
	swift-ring-builder account.builder rebalance | awk '{ print "          "$0; }'

	echo -e "\033[37;1m  * \033[33;1m Copying ring files to /srv to save them for future re-use \033[37;0m"
  echo -e "\033[37;1m    ** \033[33;1m /etc/swift/*.gz \033[37;0m"
  cp /etc/swift/*.gz      /srv
  echo -e "\033[37;1m    ** \033[33;1m /etc/swift/*.builder \033[37;0m"
	cp /etc/swift/*.builder /srv

fi

echo
echo -e "\033[33;1m##########################################\033[37;0m"
echo -e "\033[33;1m#### Starting Supervisord             ####\033[37;0m"
echo -e "\033[33;1m##########################################\033[37;0m"
echo

/usr/bin/supervisord

