FROM ruby:2.7.2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
RUN mkdir /sakazuki
WORKDIR /sakazuki
COPY Gemfile /sakazuki/Gemfile
COPY Gemfile.lock /sakazuki/Gemfile.lock
RUN bundle install -j4

COPY package.json /sakazuki/package.json
COPY yarn.lock /sakazuki/yarn.lock
RUN yarn

COPY . /sakazuki

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
