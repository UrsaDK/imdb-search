FROM centos:latest AS base
RUN yum -y update && yum clean all

ENV ENVIRONMENT=test

# Install rbenv system dependencies
RUN yum install -y \
    gcc-c++ patch readline readline-devel zlib zlib-devel \
    libyaml-devel libffi-devel openssl-devel make bzip2 \
    autoconf automake libtool bison iconv-devel git-core \
    && yum clean all

# Install application dependencies
RUN yum install -y \
    sqlite-devel \
    && yum clean all

# Create the unprivileged user
RUN groupadd moviesearch \
    && adduser -d /home/moviesearch -s /bin/false -g moviesearch moviesearch
USER moviesearch

# Setup user locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Setup user environmental variables
ENV RBENV_ROOT /home/moviesearch/.rbenv
ENV PATH ${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH

# Install rbenv, ruby-build
RUN git clone git://github.com/sstephenson/rbenv.git $RBENV_ROOT
RUN git clone git://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Import the project
WORKDIR /home/moviesearch
COPY --chown=moviesearch:moviesearch . /home/moviesearch/

# Install projects ruby
ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install; rbenv init -

# Set gem config
RUN mkdir $( dirname $(ruby -e 'print Gem::ConfigFile::SYSTEM_WIDE_CONFIG_FILE') )
RUN echo 'gem: --no-document' >> $(ruby -e 'print Gem::ConfigFile::SYSTEM_WIDE_CONFIG_FILE')

# Install all required gems
RUN gem install bundler
RUN bundle install --deployment --without development

RUN bundle exec rake test \
    && bundle exec rake db:create! \
    && bundle exec rake import:title_basics[../data/title.basics.first1000.tsv]

ENTRYPOINT ["/home/moviesearch/.rbenv/shims/bundler", "exec", "rake"]
CMD ["-T"]
