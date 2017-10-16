FROM ruby:2.4-alpine

ARG version='0.15.3'

RUN apk -Uuv add groff less python py-pip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/* && \
  gem install cfndsl -v $version && \
  gem install 'aws-sdk'
