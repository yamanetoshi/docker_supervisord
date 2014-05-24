# DOCKER-SUPERVISORD
#
# VERSION       1

FROM centos

MAINTAINER yoshiso

RUN yum -y update

#Dev tools for all Docker
RUN yum -y install git vim wget
RUN yum -y install passwd openssh openssh-server openssh-clients sudo

########################################## sshd ##############################################

# create user
RUN useradd yoshiso
RUN passwd -f -u yoshiso
RUN mkdir -p /home/yoshiso/.ssh;chown yoshiso /home/yoshiso/.ssh; chmod 700 /home/yoshiso/.ssh
ADD sshd/authorized_keys /home/yoshiso/.ssh/authorized_keys
RUN chown yoshiso /home/yoshiso/.ssh/authorized_keys;chmod 600 /home/yoshiso/.ssh/authorized_keys
# setup sudoers
RUN echo "yoshiso ALL=(ALL) ALL" >> /etc/sudoers.d/yoshiso

# setup sshd
ADD sshd/sshd_config /etc/ssh/sshd_config
RUN /etc/init.d/sshd start;/etc/init.d/sshd stop

########################################## Nginx ##############################################


# make sure the package repository is up to date
ADD nginx/nginx.repo /etc/yum.repos.d/nginx.repo
RUN chmod 0644 /etc/yum.repos.d/nginx.repo

# install memcached
RUN yum install -y nginx

ADD nginx/nginx.conf /etc/nginx/nginx.conf
Add nginx/default.conf /etc/nginx/conf.d/default.conf

# Nginx public directory

ADD nginx/src /var/www

#######################################  Supervisord  ########################################

RUN wget http://peak.telecommunity.com/dist/ez_setup.py;python ez_setup.py;easy_install distribute;
RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py;python get-pip.py;
RUN pip install supervisor

ADD supervisor/supervisord.conf /etc/supervisord.conf

###################################### Docker config #########################################


# expose for sshd, nginx

EXPOSE 2222 80

CMD ["/usr/bin/supervisord"]

