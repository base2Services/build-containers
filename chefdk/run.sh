#!/bin/bash
set -e

eval "$(/opt/chefdk/bin/chef shell-init bash)"

cd /cookbook/$COOKBOOK

if [[ "x" == "${OVERRIDE_BUNDLE}x" ]]; then
  if [[ -r 'Gemfile' ]]; then
    bundle install
  fi
fi

CLI_OPTS=""
if [[ $1 == 'rake' ]]; then
  if [[ ! -e 'Rakefile' ]]; then
    CLI_OPTS="-f /home/chef/Rakefile"
  fi
  rake $CLI_OPTS "${@:2}"
else
  exec $@
fi
