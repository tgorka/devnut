FROM tgorka/buildnut:latest

# set subname as the tag
ENV DOCKER_SUBNAME dev
# default display host set for the docker host network
ENV DISPLAY host.docker.internal:0.0

# update package list
RUN sudo apt-get update

# install vim
RUN sudo apt-get install -y --no-install-recommends \
        vim

# ssh server
RUN sudo apt-get install -y --no-install-recommends openssh-server
RUN sudo mkdir /var/run/sshd
#RUN sudo echo 'root:screencast' | chpasswd
RUN sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sudo sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
#RUN sudo echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["sudo", "/usr/sbin/sshd", "-D"]

# browser: firefox, chromium
RUN sudo apt-get install -y --no-install-recommends \
        firefox 
        #chromium-browser \
        #chromium-codecs-ffmpeg \
        #chromium-codecs-ffmpeg-extra \
        #flashplugin-installer

# install snap
RUN sudo apt-get install -y --no-install-recommends \ 
        snapd \
        squashfuse \
        fuse
RUN systemctl enable snapd
STOPSIGNAL SIGRTMIN+3
CMD [ "/sbin/init" ]

# install inteliJ IDEA ultimate
RUN set -x && VER="2018.2.6" && REL="182.5107.16" \
        && sudo curl -sL -o /tmp/ideaIU-$VER-no-jdk.tar.gz https://download.jetbrains.com/idea/ideaIU-$VER-no-jdk.tar.gz \
        && sudo tar -xz -C /opt -f /tmp/ideaIU-$VER-no-jdk.tar.gz \
        && sudo rm -rf /tmp/ideaIU-$VER-no-jdk.tar.gz \
        && echo `alias idea="/opt/idea-IU-$REL/bin/idea.sh"` | sudo tee /etc/profile.d/alias_idea.sh
        && unset VER && unset REL
