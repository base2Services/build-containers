# base2Services - Build Containers - ChefDK

Provides a container with ChefDK installed which can be used for doing cookbook building and packaging

## Details
You can pass any standard chefdk command to the container.  Basically the container has a small wrapper script which customizes the behavior depending on whether you cookbook has it's own Gemfile and/or Rakefile.

If your cookbook has it's own Gemfile a bundle install is execute before executing any other command.

If your cookbook has it's own Rakefile it will be used other wise the Rakefile executed is the one packaged in the container. See the [Container Rakefile](https://github.com/base2Services/build-containers/chefdk/blob/master/chefdk/Rakefile)

It's probably best to remove or rename your cookbooks Gemfile and Rakefile and use the one provided by the ChefDK container. If you need anything different then a pull-request is always welcome.

## How to use

The container expose a VOLUME /cookbook generally you would mount the root directory of your cookbook repo like in the example below.

Also the container allows for setting an environment variable called COOKBOOK is you cookbook repo contains multiple cookbooks. See the second example

### ChefDK Version - equivalent to chef -v
```bash
$ docker run --rm -v `pwd`:/cookbook base2/chefdk
Chef Development Kit Version: 0.12.0
chef-client version: 12.8.1
berks version: 4.3.0
kitchen version: 1.6.0
```
```bash
$ docker run --rm -v `pwd`:/cookbook -e COOKBOOK=mycookbook base2/chefdk
Chef Development Kit Version: 0.12.0
chef-client version: 12.8.1
berks version: 4.3.0
kitchen version: 1.6.0
```

### Running rake tasks

The example below is equivalent to rake -T

```bash
$ docker run --rm -v `pwd`:/cookbook base2/chefdk rake -T
[DEPRECATION] `last_comment` is deprecated.  Please use `last_description` instead.
rake foodcritic                 # Lint Chef cookbooks
rake release:changelog          # Update commit changelog
rake spec                       # Run RSpec code examples
rake test                       # Run all tests
rake test_rspec                 # Run RSpec code examples
rake version                    # Print the current version number (0.0.0)
rake version:bump               # Bump to 0.0.1
rake version:bump:major         # Bump to 1.0.0
rake version:bump:minor         # Bump to 0.1.0
rake version:bump:pre           # Bump to 0.0.1a
rake version:bump:pre:major     # Bump to 1.0.0a
rake version:bump:pre:minor     # Bump to 0.1.0a
rake version:bump:pre:revision  # Bump to 0.0.1a
rake version:bump:revision      # Bump to 0.0.1
rake version:create             # Creates a version file with an optional VERSION parameter
```

#### Running RSpec

The example below is equivalent to rspec

```bash
$ docker run --rm -v `pwd`:/cookbook base2/chefdk rspec
Fetching gem metadata from https://rubygems.org/..
Fetching version metadata from https://rubygems.org/..
Installing oj 2.14.3 with native extensions
Using version 1.0.0
Using bundler 1.11.2
Installing jsonlint 0.1.0
Bundle complete! 2 Gemfile dependencies, 4 gems now installed.
Use `bundle show [gemname]` to see where a bundled gem is installed.
...................

Finished in 2 minutes 27.9 seconds (files took 3.1 seconds to load)
19 examples, 0 failures
```

#### Running Berkshelf

The example below is equivalent to berks install

```bash
$ docker run --rm -v `pwd`:/cookbook base2/chefdk berks install
Fetching gem metadata from https://rubygems.org/..
Fetching version metadata from https://rubygems.org/..
Installing oj 2.14.3 with native extensions
Using version 1.0.0
Using bundler 1.11.2
Installing jsonlint 0.1.0
Bundle complete! 2 Gemfile dependencies, 4 gems now installed.
Use `bundle show [gemname]` to see where a bundled gem is installed.
Resolving cookbook dependencies...
Fetching 'base2' from source at .
Fetching cookbook index from https://supermarket.chef.io...
Installing 7-zip (1.0.2)
Installing apt (3.0.0)
Using base2 (1.1.34) from source at .
Installing build-essential (2.3.1)
Installing chef_handler (1.3.0)
Installing compat_resource (12.7.3)
Installing docker (2.4.26)
Installing ntp (1.6.8)
Installing resource-control (0.1.2)
Installing timezone-ii (0.2.0)
Installing users (1.7.0)
Installing windows (1.39.2)
Installing yum (3.10.0)
Installing yum-epel (0.6.6)
```
The example above had it's own Gemfile so a bundle install was executed before running the berks install. If you don't want this to happen you can pass the OVERRIDE_BUNDLE environment variable to the container

The example below is equivalent to berks package cookbooks.tar.gz

```bash
$ docker run --rm -v `pwd`:/cookbook -e OVERRIDE_BUNDLE=true base2/chefdk berks package /cookbook/cookbooks.tar.gz
Cookbook(s) packaged to /cookbook/cookbooks.tar.gz
```
