# syntax=docker/dockerfile:1.3-labs
FROM ruby:3.1.2-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install build tools and posgresql-client
RUN <<EOF
  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl=7.64.* build-essential=12.6 gnupg2=2.2.*

  curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
  echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list

  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    postgresql-client-13=13.* libpq-dev=15.* imagemagick=8:6.9.*

  apt-get clean
  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
  truncate -s 0 /var/log/**/*log
EOF

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR /sakazuki
RUN mkdir tmp/ log/

# bundle install
COPY Gemfile Gemfile.lock ./
RUN <<EOF
  gem update --system
  gem install bundler:2.3.8
  gem install foreman:0.87.2
  bundle install
  rm -rf /usr/local/bundle/cache/*gem \
    /root/.bundle/cache/* /usr/local/lib/ruby/gems/*/cache/*
  find /usr/local/bundle/gems -name 'Makefile' -print0 | \
    xargs -0 dirname | \
    xargs -n1 -P4 -I{} make -C {} clean
EOF

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
