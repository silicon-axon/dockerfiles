FROM ruby:2.4.4
MAINTAINER Silicon Axon, hello@siliconaxon.com

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD COPY vendor /usr/src/app/vendor
ONBUILD RUN bundle install

ONBUILD COPY . /usr/src/app
