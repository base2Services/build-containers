FROM alpine:latest

RUN apk add --no-cache curl git libstdc++ wget ca-certificates

ENV GLIBC_VERSION 2.23-r3

# Install glibc
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-$GLIBC_VERSION.apk" \
  &&  rm "glibc-$GLIBC_VERSION.apk" \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-bin-$GLIBC_VERSION.apk" \
  &&  rm "glibc-bin-$GLIBC_VERSION.apk" \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-i18n-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-i18n-$GLIBC_VERSION.apk" \
  &&  rm "glibc-i18n-$GLIBC_VERSION.apk"


ENV HUGO_VERSION 0.69.1
RUN mkdir -p /usr/local/src \
    && cd /usr/local/src \
    && curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-64bit.tar.gz | tar -xz \
    && mv hugo /usr/local/bin/hugo \
    && curl -L https://bin.equinox.io/c/dhgbqpS8Bvy/minify-stable-linux-amd64.tgz | tar -xz \
    && mv minify /usr/local/bin/ \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo

WORKDIR /src

EXPOSE 1313