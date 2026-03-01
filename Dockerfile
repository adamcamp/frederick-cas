# Using ruby:3.3 to match likely project requirements
FROM ruby:3.3-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  libpq-dev \
  postgresql-client \
  git \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js for asset compilation
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
  apt-get install -y nodejs && \
  rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN gem install bundler && \
  bundle install --without development test

# Copy application code
COPY . .

# Compile assets
RUN SECRET_KEY_BASE=dummy bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Run the application
CMD ["bundle", "exec", "puma", "-c", "config/puma.rb"]
