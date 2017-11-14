FROM ruby:2.4-alpine

ARG version='0.15.3'

RUN apk -Uuv add bash groff less python py-pip && \
	pip install awscli && \
	apk add --update zip git && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/* && \
	adduser -D -u 1000 jenkins

USER jenkins
RUN gem install cfndsl -v $version && \
  	gem install 'aws-sdk'
