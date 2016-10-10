FROM       node:4

# install the required dependencies to complile natice extensions

VOLUME     /usr/src/app
WORKDIR    /usr/src/app

RUN        npm init -y
RUN        npm install -g serverless
RUN        npm install -g serverless-optimizer-plugin serverless-cors-plugin
RUN        npm install -g aws-dynamodb omit-empty request url-parse bluebird dynamodb-marshaler moment node-uuid
RUN        npm install -g bluebird nodemailer async-foreach jsonwebtoken nodemailer-mandrill-transport nodemailer-sendgrid-transport nodemailer-ses-transport
RUN        npm install -g akismet-api async-foreach slack-notify string
RUN        npm install -g request omit-empty async-foreach isgd string validator async randomstring s3 node-rules slack-notify 
RUN        npm install -g xml-objtree foreach aws-dynamodb url-parse auth0
ENTRYPOINT ["sls"]

CMD ["npm install", "list"]
