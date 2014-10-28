#!/bin/bash

###
### Based on: https://github.com/ccollicutt/docker-swift-onlyone/blob/master/files/startmain.sh
###


#
# Make the rings if they don't exist already
#


# These can be set with docker run -e VARIABLE=X at runtime
SWIFT_PART_POWER=${SWIFT_PART_POWER:-7}
SWIFT_PART_HOURS=${SWIFT_PART_HOURS:-1}
SWIFT_REPLICAS=${SWIFT_REPLICAS:-1}

if [ -e /srv/account.builder ]; then
	echo "Ring files already exist in /srv, copying them to /etc/swift..."
	cp /srv/*.builder /etc/swift/
	cp /srv/*.gz      /etc/swift/
fi

# This comes from a volume, so need to chown it here, not sure of a better way
# to get it owned by Swift.
chown -R swift:swift /srv

if [ ! -e /etc/swift/account.builder ]; then

	cd /etc/swift

	# 2^& = 128 we are assuming just one drive
	# 1 replica only

	echo "No existing ring files, creating them..."

  ### http://docs.openstack.org/developer/swift/admin_guide.html#scripting-ring-creation
  ### swift-ring-builder account.builder add z1-<account-server-1>:6002/sdb1 1
  ### swift-ring-builder account.builder add z2-<account-server-2>:6002/sdb1 1
  ###
  ### The “z1”, “z2”, etc. designate zones, and you can choose whether you put devices in the same or different zones.
  ###
  ### All account servers are assumed to be listening on port 6002,
  ### and have a storage device called “sdb1” (this is a directory name created under /drives when we setup the account server).
  
	swift-ring-builder object.builder create ${SWIFT_PART_POWER} ${SWIFT_REPLICAS} ${SWIFT_PART_HOURS}
	swift-ring-builder object.builder add r1z1-127.0.0.1:6010/sdb1 1
	swift-ring-builder object.builder rebalance
  
	swift-ring-builder container.builder create ${SWIFT_PART_POWER} ${SWIFT_REPLICAS} ${SWIFT_PART_HOURS}
	swift-ring-builder container.builder add r1z1-127.0.0.1:6011/sdb1 1
	swift-ring-builder container.builder rebalance

	swift-ring-builder account.builder create ${SWIFT_PART_POWER} ${SWIFT_REPLICAS} ${SWIFT_PART_HOURS}
	swift-ring-builder account.builder add r1z1-127.0.0.1:6012/sdb1 1
	swift-ring-builder account.builder rebalance

	# Back these up for later use
	echo "Copying ring files to /srv to save them for future re-use"
	cp *.gz      /srv
	cp *.builder /srv

fi
