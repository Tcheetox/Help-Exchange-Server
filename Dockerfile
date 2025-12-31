# ---- build stage ----
FROM ruby:3.3.0-slim AS builder

ENV RAILS_ENV=production \
    BUNDLER_WITHOUT="development test"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libmariadb-dev \
    nodejs \
    yarn \
    libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs=4 --retry=3

COPY . .

# ---- runtime stage ----
FROM ruby:3.3.0-slim

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    BUNDLER_WITHOUT="development test"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    mariadb-client \
    nodejs \
    yarn \
    libmagickwand-6.q16-6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

EXPOSE 5005

CMD ["bundle", "exec", "rails", "server", "-p", "5005"]
