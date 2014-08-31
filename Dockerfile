# docker-sphinx 
# VERSION       0.1
# MAINTAINER    kongou_ae

# use RHEL Atomic
FROM fedora

# import RPM key
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-20-x86_64

RUN yum install -y git nginx passwd openssh openssh-server openssh-clients sudo gcc python-devel make vim unzip
RUN yum install -y haskell-platform texlive
RUN yum clean all

# pandoc setting
RUN cabal update
RUN cabal install zip-archive
RUN cabal install pandoc pandoc-citeproc

# SSH setting
RUN mkdir /var/run/sshd
RUN echo 'root:password' |chpasswd
RUN /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''
RUN /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''

# docker-sphinx                                                                
RUN cd /usr/local && git clone https://github.com/kongou-ae/docker-sphinx.git

# livereload setting
RUN curl -kL https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python
RUN pip install livereload

# nginx setting
RUN cp -f /usr/local/docker-sphinx/nginx.conf /etc/nginx/nginx.conf

# supervisor setting
RUN pip install supervisor 
RUN echo_supervisord_conf > /etc/supervisord.conf
RUN echo "[include]" >> /etc/supervisord.conf
RUN echo "files = supervisord/conf/*.conf" >> /etc/supervisord.conf
RUN mkdir -p /etc/supervisord/conf/
RUN cp -p /usr/local/docker-sphinx/docker_service.conf /etc/supervisord/conf/docker_service.conf

# font setting
RUN curl -O http://download.forest.impress.co.jp/pub/library/i/ipaexfont/10823/ipaexg00201.zip
RUN unzip ipaexg00201.zip
RUN mv ipaexg00201 /usr/share/fonts

EXPOSE 22 80 35729

CMD ["/usr/bin/supervisord"]

