#!/bin/sh
set -e

if [[ "x" == "${OVERRIDE_BUNDLE}x" ]]; then
  if [[ -r 'Gemfile' ]]; then
    bundle install
  fi
fi

rake -f /opt/cfndsl/Rakefile "cfn:$1"
