# syntax=docker/dockerfile:1
# default値での動作は保証されない
ARG RUBY_VERSION=3

FROM ruby:${RUBY_VERSION}-slim-bullseye

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]

# Install build tools
# hadolint ignore=DL3009
RUN <<EOF
  apt-get update -q
  apt-get upgrade -y
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl=7.74.* build-essential=12.9 gnupg2=2.2.* imagemagick=8:6.9.*
EOF

# Install posgresql-client
# hadolint ignore=DL3009
RUN <<EOF
  curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc -o /usr/share/keyrings/pgdg.asc
  echo "deb [signed-by=/usr/share/keyrings/pgdg.asc] http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list
  apt-get update -q
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends postgresql-client-13=13.* libpq-dev=17.*
EOF

# Install yarn
# hadolint ignore=DL3009
RUN <<EOF
  curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor \
    > /usr/share/keyrings/yarnkey.gpg
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" \
    > /etc/apt/sources.list.d/yarn.list
  apt-get update -q
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends yarn=1.22.*
EOF

# Install node
RUN <<EOF
  curl -sSL https://deb.nodesource.com/setup_22.x | bash -
  apt-get update -q
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends nodejs=22.*
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
COPY Gemfile Gemfile.lock .ruby-version ./
RUN <<EOF
  gem update --system
  gem install foreman:0.88.1
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
RUN yarn install && yarn cache clean

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
