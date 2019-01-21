FROM ruby:2.5-alpine

ARG version='0.3.54'

RUN adduser -D -u 1000 jenkins

USER jenkins
RUN gem install cfn-nag -v $version
