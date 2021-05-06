ARG AZURE_CLI_VERSION=2.9.1
FROM mcr.microsoft.com/azure-cli:${AZURE_CLI_VERSION}

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1
RUN mkdir /.azure && chmod -R 777 /.azure \
&& apk update \
&& apk add ruby \
           ruby-bigdecimal \
           ruby-bundler \
           ruby-io-console \
           ruby-irb \
           less \
&& apk add --virtual build-dependencies \
           build-base \
           ruby-dev \
\
&& bundle config build.nokogiri --use-system-libraries \
&& bundle config git.allow_insecure true \
&& gem install json \
&& gem install rake \
\
&& gem cleanup \
&& apk del build-dependencies \
&& rm -rf /usr/lib/ruby/gems/*/cache/* \
          /var/cache/apk/* \
          /tmp/* \
          /var/tmp/*

RUN addgroup -g 1000 jenkins && \
  adduser -u 1000 -S jenkins -G jenkins