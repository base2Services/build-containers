require 'cfndsl'
require 'cfn/aws'
require 'cfn/project'

module Cfn
  class Cf < Thor
    class_option :verbose, :type => :boolean
    class_option :config_dir, :default => 'config'
    class_option :templates_dir, :default => 'templates'
    class_option :template_glob, :default => '**/*.rb'
    class_option :output_dir, :default => 'output'

    desc "info", "Displays project information"
    def info
      say "Project info:"
      project = Cfn::Project.new
      say "  : #{project.name}"
      say "  name: #{project.name}"
    end

    desc "generate", "Generates Cloudformation templates using cfndsl"
    option :pretty, :aliases => '-p', :type => :boolean, :desc => 'outputs json pretty formatted cloudformation'
    option :params, :type => :hash, :default => {}, :desc => 'raw ruby parameters which get passed to the cfndsl template key:value'
    option :template, :aliases => '-t', :desc => 'cfndsl source template'
    option :output, :aliases => '-o', :desc => 'cloudformation template output location or filename'
    def generate()
      template_glob = options[:template] || "#{options[:templates_dir]}/#{options[:template_glob]}"
      if options[:template]
        output_dir = options[:output]
      else
        output_dir = options[:output] || options[:output_dir]
      end
      verbose "options: #{options.inspect}"
      cfn_templates(template_glob, output_dir).each do |tmpl|
        puts "rendering #{tmpl[:filename]} to #{tmpl[:output]}" if output_dir
        render_template(tmpl, yaml_extras)
      end
    end

    desc "validate <templates>", "Validates the generated cloudformation templates"
    option :region, :desc => 'AWS region'
    option :profile, :desc => 'AWS credentials profile name'
    def validate(template=nil)
      validation_dir = template || "#{options[:output_dir]}/**/*.json"
      cfn = Cfn::AwsHelper.cf_client(options[:profile], options[:region])
      Dir[validation_dir].each do |t|
        print("validating template: #{t}" )
        begin
          result = cfn.validate_template(template_body: "#{File.read(t)}")
        rescue Aws::CloudFormation::Errors::ValidationError => e
          say "...template #{t} is invalid see error log for details\n\n", :red
          puts "#{t} - #{e}\n\n"
          abort(e)
        end
        say "....is valid", :green
      end
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end

    private

    def cfn_templates(template_glob, output_dir=nil)
      templates = Dir[template_glob]
      files = []
      templates.each do |template|
        filename = "#{template}"
        output = template.sub! "#{options[:templates_dir]}/", ''
        output = output.sub! '.rb', '.json'
        if output_dir
          if output_dir.end_with?('.json')
            files << { filename: filename, output: "#{output_dir}" }
          else
            files << { filename: filename, output: "#{output_dir}/#{output}" }
          end
        else
          files << { filename: filename }
        end
      end
      files
    end

    def yaml_extras
      extra_files = Dir["#{options[:config_dir]}/*.y*ml"]
      extras = []
      extra_files.each do |extra|
        extras << [:yaml, extra]
      end
      options[:params].each do |key, value|
        extras << [:raw, "#{key}='#{value}'"]
      end
      extras
    end

    def render_template(template, extras)
      log(template)
      outputter(template) do |output|
        cf = model(template[:filename], extras)
        output.puts options[:pretty] ? JSON.pretty_generate(cf) : cf.to_json
      end
    end

    def model(filename, extras)
      fail "#{filename} doesn't exist" unless File.exist? filename
      verbose "using extras #{extras}"
      CfnDsl.eval_file_with_extras(filename, extras, verbose)
    end

    def log(template)
      type = template[:output].nil? ? "STDOUT" : template[:output]
      verbose "Writing to #{type}"
    end

    def outputter(template)
      template[:output].nil? ? yield(STDOUT) : file_output(template[:output]) { |f| yield f }
    end

    def file_output(path)
      File.open(File.expand_path(path), "w") { |f| yield f }
    end

    def verbose(msg=nil)
      STDERR.puts(msg) if options[:verbose] && msg
      options[:verbose] ? STDERR : nil
    end

    def aws_cf_client(profile_name, region)
      if use_credentials(profile_name)
        credentials = Aws::SharedCredentials.new(profile_name: profile_name)
        cfn = Aws::CloudFormation::Client.new(region: region, credentials: credentials)
      else
        cfn = Aws::CloudFormation::Client.new(region: region)
      end
      return cfn
    end

    def use_credentials(profile_name)
      use_creds = File.exists?("#{ENV['HOME']}/.aws/credentials") && !profile_name.nil?
      if use_creds
        puts "Using AWS credentials for profile #{profile_name}"
      else
        abort("you must specify config aws_profile parameter or the AWS_PROFILE environment variable") if profile_name.nil?
      end
      return use_creds
    end

  end

end
