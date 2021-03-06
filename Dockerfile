FROM golang:1.11-alpine as builder
RUN apk add --no-cache git make
ENV GOOS=linux
ENV CGO_ENABLED=0
ENV GO111MODULE=on
COPY . /src
WORKDIR /src
RUN rm -f go.sum
RUN go get
RUN go test ./...
RUN make release

FROM alpine:3.5
MAINTAINER Kim Tore Jensen <kimtjen@gmail.com>
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /src/tobac /app/tobac
EXPOSE 8080
EXPOSE 8443
CMD ["/app/tobac"]
