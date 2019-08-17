FROM ruby:2.5
LABEL maintainer="Valentin Mihov <valentin.mihov@gmail.com>"

RUN apt-get update && apt-get -y install nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ADD Gemfile /app
ADD Gemfile.lock /app

RUN bundle install --without development test

COPY . /app

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:8080"]