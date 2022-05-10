FROM ruby:3.1-alpine

RUN apk add --no-cache \
    libstdc++ \
    g++ \
    make \
    shadow \
    bash \
    && adduser -h /home/jenkins -D -u 1000 jenkins

USER jenkins

ARG KITCHEN_VERSION

RUN gem install --no-document test-kitchen -v $KITCHEN_VERSION && \
  gem install --no-document \
    inspec \
    kitchen-inspec \
    kitchen-ec2 \
    berkshelf \
    rspec-retry

CMD ["kitchen"]
