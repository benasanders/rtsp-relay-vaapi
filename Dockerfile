# FROM golang:1.17.3-alpine AS BUILD

# RUN apk --update add git

# #RTSP SIMPLE SERVER
# WORKDIR /tmp
# RUN git clone https://github.com/aler9/rtsp-simple-server.git
# WORKDIR /tmp/rtsp-simple-server

# RUN go mod download
# RUN go build -o /go/bin/rtsp-simple-server .

# #RTSP SIMPLE PROXY
# WORKDIR /tmp
# RUN git clone https://github.com/aler9/rtsp-simple-proxy.git
# WORKDIR /tmp/rtsp-simple-proxy

# RUN go mod download
# RUN go build -o /go/bin/rtsp-simple-proxy .

FROM jrottenberg/ffmpeg:4.1-vaapi

EXPOSE 8554
EXPOSE 8000
EXPOSE 8001

ENV SOURCE_URL ''
ENV STREAM_NAME 'stream'
ENV RTSP_PROXY_SOURCE_TCP 'yes'
ENV FORCE_FFMPEG 'true'
ENV FFMPEG_INPUT_ARGS ''
ENV FFMPEG_OUTPUT_ARGS='-c copy'

#RUN apk --update add gettext bash
RUN apt-get update -y
RUN apt-get install -y curl tar gettext-base
#gettext bash git

RUN curl -L https://github.com/aler9/rtsp-simple-server/releases/download/v0.17.9/rtsp-simple-server_v0.17.9_linux_amd64.tar.gz --output rtsp-simple-server_v0.17.9_linux_amd64.tar.gz
RUN tar -xf rtsp-simple-server_v0.17.9_linux_amd64.tar.gz
RUN mv rtsp-simple-server /usr/local/bin/
RUN mv rtsp-simple-server.yml /usr/local/etc/

RUN curl -L https://github.com/aler9/rtsp-simple-proxy/releases/download/v0.3.10/rtsp-simple-proxy_v0.3.10_linux_amd64.tar.gz --output rtsp-simple-proxy_v0.3.10_linux_amd64.tar.gz
RUN tar -xf rtsp-simple-proxy_v0.3.10_linux_amd64.tar.gz
RUN mv rtsp-simple-proxy /usr/local/bin/

ADD proxy.yml /tmp/proxy.yml
ADD start-relay.sh /

#ENTRYPOINT [ "/bin/bash" ]
ENTRYPOINT ["tail", "-f", "/dev/null"]
#CMD ["/start-relay.sh"]
