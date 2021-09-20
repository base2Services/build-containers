FROM python:3.9.7-alpine3.14

LABEL org.opencontainers.image.source = https://github.com/base2Services/build-containers

ADD . /code

WORKDIR /code

RUN apk add git

RUN pip install -r requirements.txt

CMD ["python3", "main.py"]
