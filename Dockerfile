FROM ruby:2.3-alpine
MAINTAINER Valentin Mihov <valentin.mihov@gmail.com>

# Install ruby deps
RUN apk add --update build-base mysql-dev libxml2-dev libxslt-dev nodejs

# Clean APK cache
RUN rm -rf /var/cache/apk/*

# Create the maycamp user
RUN addgroup maycamp && adduser -D  -G maycamp -s /bin/false maycamp
WORKDIR /maycamp

COPY Gemfile /maycamp/
COPY Gemfile.lock /maycamp/

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --without development test

COPY . /maycamp

RUN bundle exec rake assets:precompile RAILS_ENV=production

RUN mkdir -p /maycamp/tmp/pids
RUN mkdir -p /maycamp/sets
RUN mkdir -p /maycamp/logs
RUN chown maycamp:maycamp -R /maycamp

ENV TMPDIR /maycamp/tmp
VOLUME /maycamp/sets
VOLUME /maycamp/logs
VOLUME /maycamp/tmp
VOLUME /maycamp/public

USER maycamp
