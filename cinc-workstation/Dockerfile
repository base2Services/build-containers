FROM ubuntu:18.04

ARG VERSION=22.4.861
ENV DEBIAN_FRONTEND=noninteractive \
    GEM_HOME=/home/jenkins/.chefdk/gem/ruby/3.0.0 \
    PATH=/opt/cinc-workstation/bin:/opt/cinc-workstation/embedded/bin:/home/jenkins/.chefdk/gem/ruby/3.0.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Run the entire container with the default locale to be en_US.UTF-8
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN addgroup --gid 1000 jenkins && \
    adduser --home /home/jenkins --uid 1000 --disabled-password --gecos GECOS --gid 1000 jenkins

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y gcc git graphviz make rsync ssh vim-tiny wget && \
    ln -s /usr/bin/vi /usr/bin/vim && \
    wget --content-disposition "http://ftp-osl.osuosl.org/pub/cinc/files/stable/cinc-workstation/${VERSION}/ubuntu/18.04/cinc-workstation_${VERSION}-1_amd64.deb" -O /tmp/cinc-workstation.deb && \
    dpkg -i /tmp/cinc-workstation.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*log /var/log/apt/* /var/lib/dpkg/*-old /var/cache/debconf/*-old && \
    chown root:jenkins -R /opt/cinc-workstation

USER jenkins

CMD ["/bin/bash"]