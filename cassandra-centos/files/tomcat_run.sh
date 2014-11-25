#!/bin/bash

##
## Based on catalina.sh and /usr/sbin/tomcat
## http://apache.hippo.nl/tomcat/tomcat-7/v7.0.57/bin/apache-tomcat-7.0.57.tar.gz
##

if [ -f /etc/tomcat/tomcat.conf ]; then
  source /etc/tomcat/tomcat.conf
fi

export JAVA_HOME="/usr/lib/jvm/jre"
export _RUNJAVA="/usr/bin/java"
export LOGGING_CONFIG="-Djava.util.logging.config.file=/usr/share/tomcat/conf/logging.properties"
export LOGGING_MANAGER="-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager"
export JAVA_OPTS=""
export CATALINA_OPTS=""
export CATALINA_BASE="/usr/share/tomcat"
export CATALINA_HOME="/usr/share/tomcat"
export CATALINA_TMPDIR="/var/cache/tomcat/temp"
export CLASSPATH="${CATALINA_BASE}/bin/bootstrap.jar:${CATALINA_BASE}/bin/tomcat-juli.jar"
export JAVA_ENDORSED_DIRS="${CATALINA_BASE}/endorsed"


echo 
echo -e "${WHITE}  * ${YELLOW}JAVA_HOME${WHITE}.........: ${CYAN}${JAVA_HOME}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}_RUNJAVA${WHITE}..........: ${CYAN}${_RUNJAVA}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}LOGGING_CONFIG${WHITE}....: ${CYAN}${LOGGING_CONFIG}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}LOGGING_MANAGER${WHITE}...: ${CYAN}${LOGGING_MANAGER}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}JAVA_OPTS${WHITE}.........: ${CYAN}${JAVA_OPTS}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}CATALINA_OPTS${WHITE}.....: ${CYAN}${CATALINA_OPTS}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}CATALINA_BASE${WHITE}.....: ${CYAN}${CATALINA_BASE}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}CATALINA_HOME${WHITE}.....: ${CYAN}${CATALINA_HOME}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}CATALINA_TMPDIR${WHITE}...: ${CYAN}${CATALINA_TMPDIR}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}CLASSPATH${WHITE}.........: ${CYAN}${CLASSPATH}${NORMAL}"
echo -e "${WHITE}  * ${YELLOW}JAVA_ENDORSED_DIRS${WHITE}: ${CYAN}${JAVA_ENDORSED_DIRS}${NORMAL}"
echo


eval exec "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
  -Djava.endorsed.dirs="\"$JAVA_ENDORSED_DIRS\"" -classpath "\"$CLASSPATH\"" \
  -Dcatalina.base="\"$CATALINA_BASE\"" \
  -Dcatalina.home="\"$CATALINA_HOME\"" \
  -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
  org.apache.catalina.startup.Bootstrap "$@" start

#eval exec "/usr/bin/java" "-Djava.util.logging.config.file=/apache-tomcat-7.0.57/conf/logging.properties" -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
# -Djava.endorsed.dirs="/apache-tomcat-7.0.57/endorsed" -classpath "/apache-tomcat-7.0.57/bin/bootstrap.jar:/apache-tomcat-7.0.57/bin/tomcat-juli.jar" \
# -Djava.security.manager \
# -Djava.security.policy=="\"$CATALINA_BASE/conf/catalina.policy\"" \
# -Dcatalina.base="/apache-tomcat-7.0.57" \
# -Dcatalina.home="/apache-tomcat-7.0.57" \
# -Djava.io.tmpdir="/apache-tomcat-7.0.57/temp" \
# org.apache.catalina.startup.Bootstrap start


##### /etc/init.d/tomcat7
# export JAVA_HOME="/usr/lib/jvm/jre" ;
# export CATALINA_BASE="/usr/share/tomcat" ;
# export CATALINA_HOME="/usr/share/tomcat" ;
# export JASPER_HOME="/usr/share/tomcat" ;
# export CATALINA_TMPDIR="/var/cache/tomcat/temp" ;
# export TOMCAT_USER="tomcat" ;
# export SECURITY_MANAGER="false" ;
# export SHUTDOWN_WAIT="30" ;
# export SHUTDOWN_VERBOSE="false" ;
# export CATALINA_PID="/var/run/tomcat.pid" ;
# /usr/sbin/tomcat

##### /usr/sbin/tomcat
#  ${JAVACMD} $JAVA_OPTS $CATALINA_OPTS \
#    -classpath "$CLASSPATH" \
#    -Dcatalina.base="$CATALINA_BASE" \
#    -Dcatalina.home="$CATALINA_HOME" \
#    -Djava.endorsed.dirs="$JAVA_ENDORSED_DIRS" \
#    -Djava.io.tmpdir="$CATALINA_TMPDIR" \
#    -Djava.util.logging.config.file="${CATALINA_BASE}/conf/logging.properties" \
#    -Djava.util.logging.manager="org.apache.juli.ClassLoaderLogManager" \
#    org.apache.catalina.startup.Bootstrap start



