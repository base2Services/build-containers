FROM ruby:2.4-alpine

ARG CFNDSL_VERSION='0.16.12'
ARG AWS_SPEC_VERSION='2.28.0'

RUN apk -Uuv add bash groff less python py-pip && \
	pip install awscli && \
	apk add --update zip git && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/* && \
	adduser -D -u 1000 jenkins

USER jenkins

RUN gem install cfndsl -v $CFNDSL_VERSION

RUN cfndsl -u $AWS_SPEC_VERSION

CMD ['cfndsl', '--version']
