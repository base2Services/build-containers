FROM ruby:2.5-alpine

ARG version='0.8.0'

RUN adduser -D -u 1000 jenkins

USER jenkins
RUN gem install cfn_manage -v $version
