FROM ubuntu:14.04.1

MAINTAINER Devon Hubner <devon@hubner.org>

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update
# RUN apt-get upgrade -y


## Adding webupd8team PPA for Java

# for <= 12.04
# sudo apt-get install python-software-properties

# for >= 12.10
# sudo apt-get install software-properties-common

#RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:webupd8team/java -y

RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get install -y git curl wget unzip

RUN apt-get install -y oracle-java7-installer

### Download Bukkit Server
RUN mkdir -p /opt/minecraft

##### 2014-08-20 :: 1.7.9
RUN wget -O /opt/minecraft/craftbukkit.jar http://cbukk.it/craftbukkit-beta.jar
##### 2014-08-20 :: 1.6.4
# RUN wget -O /opt/minecraft/craftbukkit.jar http://dl.bukkit.org/latest-rb/craftbukkit.jar

### pass server.properties via -v
### -v $(pwd)/server.properties:/opt/minecraft/server.properties
#ADD server.properties /opt/minecraft

# To add someone to it, use /op <ExactPlayerName>.
# To remove someone from it, use /deop <ExactPlayerName>
# Server operaters get to use commands like /gamemode and /ban and stuff like that

### pass ops.txt via -v
### -v $(pwd)/ops.txt:/opt/minecraft/ops.txt
#ADD ops.txt /opt/minecraft

RUN touch /opt/minecraft/ops.txt
RUN touch /opt/minecraft/white-list.txt

# 01:27:20 [WARNING] server.properties does not exist
# 01:27:22 [WARNING] Failed to load operators list: java.io.FileNotFoundException: ./ops.txt (No such file or directory)
# 01:27:22 [WARNING] Failed to load white-list: java.io.FileNotFoundException: ./white-list.txt (No such file or directory)


RUN mkdir -p /opt/minecraft/plugins
RUN wget -O /opt/minecraft/plugins/Essentials.zip       http://dev.bukkit.org/media/files/780/922/Essentials.zip
RUN wget -O /opt/minecraft/plugins/Essentials-extra.zip http://dev.bukkit.org/media/files/780/921/Essentials-extra.zip
RUN unzip -d /opt/minecraft/plugins -j /opt/minecraft/plugins/Essentials.zip
RUN unzip -d /opt/minecraft/plugins -j /opt/minecraft/plugins/Essentials-extra.zip


EXPOSE 25565

WORKDIR /opt/minecraft

####
#### There can only be one CMD instruction in a Dockerfile.
#### If you list more than one CMD then only the last CMD will take effect.
####
CMD (echo -e "\n\n" ; echo -e "\033[32;1m###############################################################" ; echo -e "\033[32;1m##" ;
echo -e "\033[32;1m## \033[33;1mBUKKIT MINECRAFT SERVER\n\033[32;1m##" ; echo -e "\033[32;1m###############################################################" ;
echo -e "\033[37;0m" ; echo -e "\033[37;1m  * \033[33;1mStarting Bukkit Minecraft Server \033[37;1m... \033[37;0m" ; java -Xmx1024M -Xms768M -jar craftbukkit.jar nogui)




