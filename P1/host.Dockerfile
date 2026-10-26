FROM alpine:3.21


RUN apk add --no-cache \
	busybox \
	iproute2 \
	iputils \ 
	tcpdump

CMD ["sleep", "infinity"]
