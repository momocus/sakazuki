FROM ruby:3.0.2-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install build tools, posgresql-client, yarn and node
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl=7.64.* build-essential=12.6 gnupg2=2.2.* imagemagick=8:6.9.* \
    git=1:2.20.* && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/**/*log && \
    \
    curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list && \
    \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
    tee /etc/apt/sources.list.d/yarn.list && \
    \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    nodejs=12.* postgresql-client-13=13.* libpq-dev=13.* yarn=1.22.* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/**/*log

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR /sakazuki
RUN mkdir tmp/ log/

# bundle install
COPY Gemfile Gemfile.lock ./
RUN gem update --system && \
    gem install bundler:2.2.7 && \
    bundle install && \
    rm -rf /usr/local/bundle/cache/*gem \
    /root/.bundle/cache/* /usr/local/lib/ruby/gems/*/cache/* && \
    find /usr/local/bundle/gems -name 'Makefile' -print0 | \
    xargs -0 dirname | \
    xargs -n1 -P4 -I{} make -C {} clean

# yarn install
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn/releases/yarn-2.4.2.cjs ./.yarn/releases/yarn-2.4.2.cjs
RUN yarn install && yarn cache clean

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
