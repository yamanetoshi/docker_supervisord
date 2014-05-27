# DOCKER-SUPERVISORD
#
# VERSION       1

FROM ubuntu

MAINTAINER yamanetoshi

RUN apt-get update

#Dev tools for all Docker
RUN apt-get install -y git-core vim wget
RUN apt-get install -y passwd ssh openssh-server openssh-client sudo

########################################## sshd ##############################################

# create user
RUN useradd -m rms 
#RUN passwd -f -u rms
#RUN mkdir -p /home/rms/.ssh;chown rms /home/rms/.ssh; chmod 700 /home/rms/.ssh
#ADD sshd/authorized_keys /home/rms/.ssh/authorized_keys
#RUN chown rms /home/rms/.ssh/authorized_keys;chmod 600 /home/rms/.ssh/authorized_keys

ADD sshd/authorized_keys /home/rms/.ssh/
RUN chmod 600 /home/rms/.ssh/authorized_keys
RUN chown -R rms:rms /home/rms/.ssh
RUN chmod 700 /home/rms/.ssh

# setup sudoers
RUN echo "rms ALL=(ALL) ALL" >> /etc/sudoers.d/rms

# setup sshd
ADD sshd/sshd_config /etc/ssh/sshd_config
RUN /etc/init.d/ssh start;/etc/init.d/ssh stop

########################################## Nginx ##############################################


# make sure the package repository is up to date
#ADD nginx/nginx.repo /etc/yum.repos.d/nginx.repo
#RUN chmod 0644 /etc/yum.repos.d/nginx.repo

# install memcached
RUN apt-get install -y nginx

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

CMD ["/usr/local/bin/supervisord"]

