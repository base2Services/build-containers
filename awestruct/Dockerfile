FROM       fedora:22

# install the required dependencies to complile natice extensions
RUN        dnf -y install gcc-c++ make ruby-devel libxml2-devel libxslt-devel findutils git ruby

RUN        groupadd -r dev && useradd  -g dev -u 1000 dev 
RUN        mkdir -p /home/dev
RUN        chown dev:dev /home/dev

# From here we run everything as dev user
USER       dev

# Setup all the env variables needed for ruby
ENV        HOME /home/dev
ENV        GEM_HOME $HOME/.gems
ENV        GEM_PATH $HOME/.gems
ENV        PATH $PATH:$GEM_HOME/bin
ENV        LC_ALL en_US.UTF-8
ENV        LANG en_US.UTF-8
RUN        mkdir $HOME/.gems
ADD        Gemfile /tmp/Gemfile
# Install Rake and Bundler for driving the Awestruct build & site
RUN        gem install -N rake bundler

# Clone hibernate.org in order to run the setup task
# RUN        git clone https://github.com/hibernate/in.relation.to.git (3)
# RUN        cd $HOME/hibernate.org && git checkout production && rake setup

# We need to patch awestruct to make auto generation work. On mounted volumes file
# change montoring will only work with polling
RUN        gem install awestruct
RUN        cd /tmp
RUN        bundle install

EXPOSE     4242
VOLUME     $HOME/base2website
WORKDIR    $HOME/base2website

ENTRYPOINT ["awestruct"]

CMD ["--help"]
