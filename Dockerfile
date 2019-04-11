FROM onlinegears/base:latest

RUN apt update && apt install -y \
	lxde xrdp terminator \
	socat \
	&& apt clean

COPY start.sh /start.sh

ENTRYPOINT /start.sh
