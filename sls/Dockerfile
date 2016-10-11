FROM       node:4

# install the required dependencies to complile native extensions

RUN        groupadd -r dev && useradd  -g dev -u 1000 dev
RUN        mkdir -p /usr/src
RUN        mkdir -p /usr/src/app
RUN        chown dev:dev /usr/src/app

# From here we run everything as dev user
USER       dev

VOLUME     /usr/src/app
WORKDIR    /usr/src/app

ENV        HOME /usr/src/app
RUN        npm init -y
RUN        npm install -g serverless@0.5.6
RUN        npm install -g serverless-optimizer-plugin@2.5.1 serverless-cors-plugin@0.4.1
RUN        npm install -g aws-dynamodb omit-empty request url-parse bluebird dynamodb-marshaler moment node-uuid
RUN        npm install -g bluebird nodemailer async-foreach jsonwebtoken nodemailer-mandrill-transport nodemailer-sendgrid-transport nodemailer-ses-transport
RUN        npm install -g akismet-api async-foreach slack-notify string
RUN        npm install -g request omit-empty async-foreach isgd string validator async randomstring s3 node-rules slack-notify
RUN        npm install -g xml-objtree foreach aws-dynamodb url-parse auth0
ENTRYPOINT ["sls"]

CMD [list]
