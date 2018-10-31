FROM openjdk:slim



## Install dependencies
COPY apt-requirements.txt /tmp/apt-requirements.txt

RUN apt-get -qq update \
	&& apt-get -qqy install --no-install-recommends $(cat /tmp/apt-requirements.txt) \
	&& rm -rf /var/lib/apt/lists/* \
	pip3 install pipenv && \
	pip3 install --upgrade pip

ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 18.06.1-ce

RUN set -ex; \
	curl "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
	| tar xz --strip-components 1 -C /usr/local/bin/  && \
	dockerd -v && \
	docker -v


COPY modprobe.sh /usr/local/bin/modprobe
COPY docker-entrypoint.sh /usr/local/bin/
COPY worker.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /app

CMD worker.sh
