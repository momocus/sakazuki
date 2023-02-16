# syntax=docker/dockerfile:1.3-labs
FROM ruby:3.1.2-slim-bullseye

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install build tools, posgresql-client, yarn and node
RUN <<EOF
  apt-get update -qq
  apt-get upgrade -y
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl=7.74.* build-essential=12.9 gnupg2=2.2.*

  curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
  echo "deb http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list

  curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor \
    > /usr/share/keyrings/yarnkey.gpg
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" \
    > /etc/apt/sources.list.d/yarn.list

  curl -sSL https://deb.nodesource.com/setup_18.x | bash -

  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    nodejs=18.* postgresql-client-13=13.* libpq-dev=15.* yarn=1.22.* \
    imagemagick=8:6.9.*

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

# yarn install
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn/releases/ ./.yarn/releases/
COPY .yarn/plugins/ ./.yarn/plugins/
RUN yarn install && yarn cache clean

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
