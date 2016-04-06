# base2Services - Build Containers - cfn

Provides a container with cfndsl installed along with additional commands for creating/updating/deleting environments using cloudformation

## Details

If your project has it's own Gemfile a bundle install is execute before executing any other command.


## How to use

The container exposes a VOLUME /build, which generally you would mount the root directory of your cfndsl project. See example below.

If your project has it's own Gemfile you can suppress the bundle install by passing the OVERRIDE_BUNDLE=true environment variable to the container

### Project Structure

To use this container your project needs to follow a particular convention
```bash
project
├── Gemfile
├── README.md
├── config
│   ├── app-ami-1.yml
│   ├── default_params.yml
├── output
│   ├── app.json
│   ├── master.json
└── templates
    ├── app.rb
    ├── master.rb
```
#### custom Gemfile

If your templates use any custom gems you can add them to this Gemfile and a bundle install will get executed prior to the template generation.

#### config directory

Contains yaml files that get automatically loaded by cfndsl as template parameters. The default_params.yml file is required as it sets some default used by the container

default_params.yml
```yaml
#cfndsl default params

application_name: 'example'

source_bucket: source.example.com
source_region: ap-southeast-2
```
* application_name: the application name that can be used within cndsl templates

* source_bucket: the S3 bucket to upload the generated cloudformation to. Note this bucket needs to exist

* source_region: the region where the source_bucket has been created

default_params.yml can also contain any other parameters that you want to use within your cfndsl templates

#### templates directory

The location of the cfndsl source ruby templates. Any .rb file in this directory will get executed by the generate command

#### output directory

The location of the cfndsl cloudformation templates get generated


### CFN Commands

#### Container environment variables

| variable        | description |
| --------------- | ----------- |
| OVERRIDE_BUNDLE | when set this skip the bundle install for any custom Gemfile |
| AWS_PROFILE     | if you provide custom aws credentials using a volume mount you need to provide a aws profile name either config aws_profile variable in the default_params.yml or you can set this environment variable |

#### generate - generates cloudformation from cfndsl templates
```bash
$ docker run --rm -v `pwd`:/build -e OVERRIDE_BUNDLE=true base2/cfn generate
[DEPRECATION] `last_comment` is deprecated.  Please use `last_description` instead.
Writing to output/app.json
.....
Running raw ruby code cf_version='dev'
Loading template file templates/app.rb
```

#### validate - validates the generated cloudformation templates
```bash
$ docker run --rm -v `pwd`:/build -v $HOME/.aws/credentials:/root/.aws/credentials -e OVERRIDE_BUNDLE=true -e AWS_PROFILE=base2 base2/cfn validate
[DEPRECATION] `last_comment` is deprecated.  Please use `last_description` instead.
Using AWS credentials for profile base2
validating template: output/app.json....is valid
validating template: output/master.json....is valid
validating template: output/vpc.json....is valid
```
The example above shows how to pass your aws credentials to the container and select with profile to use. You use pass credentials you MUST specify a profile you can't use the default credentials.

#### upload - upload the generated cloudformation templates to S3
```bash
$ docker run --rm -v `pwd`:/build -v $HOME/.aws/credentials:/root/.aws/credentials -e OVERRIDE_BUNDLE=true -e AWS_PROFILE=base2 base2/cfn upload
[DEPRECATION] `last_comment` is deprecated.  Please use `last_description` instead.
Using AWS credentials for profile base2
upload: output/app.json to s3://source.example.ci.base2.services/cloudformation/dev/app.json
upload: output/master.json to s3://source.example.ci.base2.services/cloudformation/dev/master.json
upload: output/vpc.json to s3://source.example.ci.base2.services/cloudformation/dev/vpc.json 
```

#### create - runs the cloudformation create stack
```bash
TODO
```

#### update - runs the cloudformation update stack
```bash
TODO
```

#### delete - runs the cloudformation delete stack
```bash
TODO
```
