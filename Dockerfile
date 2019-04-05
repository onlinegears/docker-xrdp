FROM onlinegears/base:latest

RUN apt update && apt install -y \
	lxde xrdp terminator \
	&& apt clean

COPY start.sh /start.sh

ENTRYPOINT /start.sh
