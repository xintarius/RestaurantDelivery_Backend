FROM ruby:3.4.1-slim AS builder

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    git \
    pkg-config

  WORKDIR /app

  COPY Gemfile Gemfile.lock ./
  RUN bundle config set --local deployment 'true' \
    && bundle config set --local without 'deployment test' \
    && bundle install --jobs 4 --retry 3

COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/

FROM ruby:3.4.1-slim

RUN  apt-get update -qq && apt-get install -y \
     libpq-dev \
     curl \
     tzdata \
     && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

RUN useradd -m rails && \
    mkdir -p tmp/pids log storage && \
    chown -R rails:rails /app

USER rails

EXPOSE 3001

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001"]