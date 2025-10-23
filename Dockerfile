# build
FROM golang:1.25 as builder
WORKDIR         /go/src/moul.io/sshportal
COPY            go.mod go.sum ./
RUN             GOPROXY=goproxy.cn go mod download
COPY            . ./
RUN             make _docker_install

# minimal runtime
FROM            alpine
COPY            --from=builder /go/bin/sshportal /bin/sshportal
ENTRYPOINT      ["/bin/sshportal"]
CMD             ["server"]
EXPOSE          2222
HEALTHCHECK     CMD /bin/sshportal healthcheck --wait
