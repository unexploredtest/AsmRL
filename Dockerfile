FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends make gcc-arm-linux-gnueabi qemu-user

WORKDIR /app
COPY . .

RUN make

CMD ["qemu-arm", "./main"]