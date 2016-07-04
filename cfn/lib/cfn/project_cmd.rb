require 'cfn/project'

module Cfn

  class ProjectCmd < Thor
    class_option :verbose, :type => :boolean

    desc "create <project_name>", "creates a cfn project"
    option :git_url, :desc => "project template git repo", :required => true
    option :git_branch, :desc => "git branch/tag name", :default => "master"
    option :source_bucket, :desc => "S3 bucket name where to store the cloudformation templates", :required => true
    option :source_region, :desc => "region where to store the cloudformation templates", :default => "ap-southeast-2"
    def create_project(project_name)
      project = Cfn::Project.create(project_name, options)
      say "Project #{project.name} has been successfully created"
    end

    desc "info", "displays info about the current project"
    option :project_dir, :desc => "the project directory, defaults to current directory", :default => Dir.pwd
    def info
      project = Cfn::Project.new(options[:project_dir])
      project.display_info
    end
  end
end
