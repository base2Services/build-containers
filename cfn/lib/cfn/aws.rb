require 'aws-sdk'

module Cfn
  class AwsHelper
    def self.cf_client(profile_name, region)
      if use_credentials(profile_name)
        credentials = Aws::SharedCredentials.new(profile_name: profile_name)
        cfn = Aws::CloudFormation::Client.new(region: get_region(region), credentials: credentials)
      else
        cfn = Aws::CloudFormation::Client.new(region: get_region(region))
      end
      return cfn
    end

    def self.s3_client(profile_name, region)
      region = get_region(region)
      if use_credentials(profile_name)
        credentials = Aws::SharedCredentials.new(profile_name: profile_name)
        cfn = Aws::S3::Client.new(region: get_region(region), credentials: credentials)
      else
        cfn = Aws::S3::Client.new(region: get_region(region))
      end
      return cfn
    end

    def self.use_credentials(profile_name)
      profile_name = profile_name || ENV['AWS_PROFILE']
      use_creds = File.exists?("#{ENV['HOME']}/.aws/credentials") && !profile_name.nil?
      if use_creds
        puts "Using AWS credentials for profile #{profile_name}"
      else
        abort("you must specify profile option or the AWS_PROFILE environment variable") if profile_name.nil?
      end
      return use_creds
    end

    def self.get_region(region)
      region = region || ENV['AWS_REGION']
      if region.nil?
        abort('you must specify region option or the AWS_REGION environment variable')
      end
      region
    end
  end
end
