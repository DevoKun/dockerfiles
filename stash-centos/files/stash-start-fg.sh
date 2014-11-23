#!/bin/bash

echo -e "\n\n"
echo -e "\033[32;1m###############################################################"
echo -e "\033[32;1m##                                                           ##"
echo -e "\033[32;1m## \033[33;1m         STASH                        \033[32;1m##"
echo -e "\033[32;1m##                                                           ##"
echo -e "\033[32;1m###############################################################"
echo -e "\033[37;0m"
echo -e "\033[37;1m  * \033[33;1mUser ID..: \033[37;1m $UID \033[37;0m"
echo -e "\033[37;1m  * \033[33;1mUser Name: \033[37;1m $USER \033[37;0m"
echo
echo
chown -R stash:stash /opt/stash
chown -R stash:stash /var/lib/stash
export STASH_HOME=/var/lib/stash
/opt/stash/bin/start-stash.sh -fg
