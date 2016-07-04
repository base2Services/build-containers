require 'thor'
require_relative 'cfn/cf'
require_relative 'cfn/project_cmd'
require_relative 'cfn/version'

class Cfn::Cli < Thor

  check_unknown_options! :except => :with_optional

  map %w[--version -v] => :__print_version

  desc "--version, -v", "print the version"
    def __print_version
      puts Cfn::VERSION
    end

  desc "cf SUBCOMMAND ...ARGS", "generates/validates/uploads cloudformation"
  subcommand "cf", Cfn::Cf
  
  desc "project SUBCOMMAND ...ARGS", "manages a cfn project"
  subcommand "project", Cfn::ProjectCmd
end
