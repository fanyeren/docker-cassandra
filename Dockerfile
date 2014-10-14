# Creates a base ubuntu image with serf and dnsmasq
#
# it aims to create a dynamic cluster of docker containers
# each able to refer other by fully qulified domainnames
#
# this isn't trivial as docker has readonly /etc/hosts
#
# The docker images was directly taken from sequenceiq and converetd to ubuntu image
# because I wanted to create the cluster on ubuntu.

FROM poklet/cassandra
MAINTAINER xiahoufeng

RUN echo "root:test123456" | chpasswd
RUN useradd -d /home/work -m -s /bin/bash work
RUN mkdir -p /home/work/opdir
RUN echo "work:test123456" | chpasswd
RUN echo 'ls -lF --color=auto' >> /home/work/.bashrc

ADD 0.6.3_linux_amd64.zip /tmp/serf.zip

# dnsmasq configuration
ADD dnsmasq.conf /etc/dnsmasq.conf
ADD resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf

# install serfdom.io
#RUN unzip /tmp/serf.zip -d /bin
ADD serf /bin/serf
RUN chmod +x /bin/serf

ENV SERF_CONFIG_DIR /etc/serf

# configure serf
ADD serf-config.json $SERF_CONFIG_DIR/serf-config.json

ADD event-router.sh $SERF_CONFIG_DIR/event-router.sh
RUN chmod +x  $SERF_CONFIG_DIR/event-router.sh

ADD handlers $SERF_CONFIG_DIR/handlers

ADD start-serf-agent.sh  $SERF_CONFIG_DIR/start-serf-agent.sh
RUN chmod +x  $SERF_CONFIG_DIR/start-serf-agent.sh

RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

ADD bashrc /home/work/.bashrc
RUN chown -R work /home/work

EXPOSE 7373 7946 22 61621 7000 7001 7199 8012 9042 9160

#ENTRYPOINT ["/bin/bash", "/etc/serf/start-serf-agent.sh"]
