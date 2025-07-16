FROM golang:1.24-alpine AS build

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

# hadolint ignore=DL3018
RUN apk update \
	&& apk add --no-cache \
	make binutils git

WORKDIR /app

COPY . .

RUN make build

FROM alpine:3.20.3 AS runtime

COPY --from=build /app/token-sync-controller /usr/bin/token-sync-controller

ENTRYPOINT ["/usr/bin/token-sync-controller"]

CMD ["--help"]
