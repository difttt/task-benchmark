FROM alpine:latest
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && apk add wrk curl jq
COPY . /benchmark
WORKDIR /benchmark
ENTRYPOINT ["./benchmark.sh"]
