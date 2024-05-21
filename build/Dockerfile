#
# Sample system container with alpine + supervisord + sshd + docker
#
# Run with:
#
# $ docker run --runtime=sysbox-runc -d -P <this-image>
#

FROM ubuntu

RUN apt-get update \
	&& apt-get install -y \
	curl \
	wget \
	supervisor 

# docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh

# supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# COPY supervisord.conf /etc/

# entrypoint
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
