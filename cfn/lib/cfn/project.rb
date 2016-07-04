require 'yaml'
require 'fileutils'

module Cfn
  class Project
    PROJECT_FILE = "project.yml"

    attr_accessor :project_dir
    attr_accessor :name
    attr_accessor :source_region
    attr_accessor :source_bucket
    attr_accessor :git_url
    attr_accessor :git_branch
    attr_accessor :params

    def self.create(project_name, project_config)
      create_project_file(project_name,project_config)
      p = Cfn::Project.new(project_name)
      p.git_source_sync
    end

    def initialize(dir=nil)
      @project_dir = dir || Dir.pwd
      project = "#{@project_dir}/#{PROJECT_FILE}"
      if File.exist?(project)
        @project = YAML.load(File.read(project))
        @name = @project['project_name']
        @source_region = @project['source_region']
        @source_bucket = @project['source_bucket']
        @git_url = @project['git']['url']
        @git_branch = @project['git']['branch']
        @params = {}
        Dir["#{project_dir}/config/**/*.y*ml"].each do |file|
          @params = @params.merge(YAML.load(File.read(file)))
        end
      else
        raise "Failed to load project #{project}"
      end
    end

    def git_source_sync(templates_only=false)
      system ("git archive #{git_url} #{git_branch} | tar xvf -C #{@project_dir}")
    end

    def display_info
      puts "project: #{name}"
    end

    private

    def self.create_project_file(project_name, project_config)
      project = "#{project_name}/#{PROJECT_FILE}"
      if File.exist?(project)
        raise "project #{project_name} already exist"
      end
      FileUtils::mkdir_p project_name
      project_tmpl = """# CFN Project

project_name: #{project_name}

# Project Template Source Git repo
git:
  url: #{project_config[:git_url]}
  branch: #{project_config[:git_branch]}

# AWS config
aws:
  source_bucket: #{project_config[:source_bucket]}
  source_region: #{project_config[:source_region]}
"""
      File.open(project, 'w') { |f| f.write(project_tmpl) }
    end
  end
end
