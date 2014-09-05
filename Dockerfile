# doc-man 
# VERSION       0.1
# MAINTAINER    kongou_ae

# use RHEL Atomic
FROM fedora

# import RPM key
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-20-x86_64

RUN yum install -y git passwd openssh openssh-server openssh-clients sudo gcc python-devel make vim unzip
RUN yum install -y haskell-platform texlive texlive-luatexja texlive-lualibs texlive-collection-langcjk texlive-euenc
RUN yum install -y wget pcre-devel openssl openssl-devel
RUN yum clean all

# SSH setting
RUN mkdir /var/run/sshd
RUN echo 'root:password' |chpasswd
RUN /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''
RUN /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''

# livereload setting
RUN curl -kL https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python
RUN pip install livereload

# supervisor setting
RUN pip install supervisor 
RUN echo_supervisord_conf > /etc/supervisord.conf
RUN echo "[include]" >> /etc/supervisord.conf
RUN echo "files = supervisord/conf/*.conf" >> /etc/supervisord.conf
RUN mkdir -p /etc/supervisord/conf/
ADD doc-man_service.conf /etc/supervisord/conf/doc-man_service.conf

# font setting
RUN curl -O http://download.forest.impress.co.jp/pub/library/i/ipaexfont/10823/ipaexg00201.zip
RUN unzip ipaexg00201.zip
RUN mv ipaexg00201 /usr/share/fonts

# pandoc setting
RUN yum install -y pandoc pandoc-citeproc pandoc-pdf
RUN yum clean all

# nginx setting                                                                                                        
RUN cd /usr/local/src && wget http://nginx.org/download/nginx-1.7.4.tar.gz && tar xzvf nginx-1.7.4.tar.gz  
RUN cd /usr/local/src/nginx-1.7.4 && git clone https://github.com/arut/nginx-dav-ext-module.git
RUN groupadd nginx && useradd -g nginx nginx 
RUN mkdir /home/doc-man && mkdir /etc/nginx && cd /usr/local/src/nginx-1.7.4 && ./configure --prefix=/usr/local/nginx-1.7.4 --sbin-path=/usr/sbin/nginx --with-http_ssl_module --with-http_dav_module --add-module=./nginx-dav-ext-module
RUN yum install -y expat expat-devel
RUN cd /usr/local/src/nginx-1.7.4 && make && make install
ADD nginx.conf /usr/local/nginx-1.7.4/conf/nginx.conf
ADD docman.crt /usr/local/nginx-1.7.4/docman.crt
ADD server.key /usr/local/nginx-1.7.4/server.key

EXPOSE 22 443 35729

CMD ["/usr/bin/supervisord"]
