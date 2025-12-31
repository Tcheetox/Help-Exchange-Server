# Use the official Ruby image
FROM ruby:3.3.0-slim

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

# Install necessary dependencies
RUN apt-get update -qq && apt-get install -y nodejs mariadb-client libmariadb-dev yarn libmagickwand-dev \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Install bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port to the host
EXPOSE 5005

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-p", "5005"]
