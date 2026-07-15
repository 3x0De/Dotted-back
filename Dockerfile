FROM ruby:3.3

ENV GEM_HOME="/usr/local/bundle"
ENV PATH="${GEM_HOME}/bin:${PATH}"

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 4567

CMD ["bundle", "exec", "rerun", "--", "rackup", "-o", "0.0.0.0", "-p", "4567"]