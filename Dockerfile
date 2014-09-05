# doc-man 
# VERSION       0.1
# MAINTAINER    kongou_ae

# use RHEL Atomic
FROM fedora

# import RPM key
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-20-x86_64

RUN yum install -y git passwd openssh openssh-server openssh-clients sudo gcc python-devel make vim unzip
RUN yum install -y haskell-platform texlive
RUN yum clean all

# pandoc setting
RUN cabal update
RUN cabal install zip-archive
RUN cabal install pandoc pandoc-citeproc
RUN yum -y install texlive-luatexja texlive-lualibs texlive-collection-langcjk texlive-euenc

# SSH setting
RUN mkdir /var/run/sshd
RUN echo 'root:password' |chpasswd
RUN /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''
RUN /usr/bin/ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''

# livereload setting
RUN curl -kL https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python
RUN pip install livereload

# nginx setting                                                                                                        
RUN yum install -y wget pcre-devel openssl openssl-devel                                                                                          
RUN cd /usr/local/src && cd /usr/local/src && wget http://nginx.org/download/nginx-1.7.4.tar.gz && tar xzvf nginx-1.7.4.tar.gz  
RUN cd /usr/local/src/nginx-1.7.4 && git clone https://github.com/arut/nginx-dav-ext-module.git                                                         
RUN cd /usr/local/src/nginx-1.7.4 && ./configure --prefix=/usr/local/nginx-1.7.4 --user=nginx --group=nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/ --with-http_ssl_module --with-http_dav_module --add-module=./nginx-dav-ext-module
ADD nginx.conf /etc/nginx/nginx.conf                                                                                   
RUN mkdir /home/doc-man  

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

EXPOSE 22 80 35729

CMD ["/usr/bin/supervisord"]
