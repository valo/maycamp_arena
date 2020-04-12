FROM ruby:2.5
LABEL maintainer="Valentin Mihov <valentin.mihov@gmail.com>"

RUN apt-get update \
  && apt-get -y install nodejs docker.io g++ default-jdk \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ADD Gemfile /app
ADD Gemfile.lock /app

RUN bundle install

COPY . /app

ARG SECRET_TOKEN
ARG SECRET_KEY_BASE
ARG RAILS_ENV

RUN rake assets:precompile

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:8080"]