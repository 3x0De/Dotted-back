FROM ruby:3.3

WORKDIR /app

COPY Gemfile ./

RUN bundle install

COPY . .

EXPOSE 4567

CMD ["rerun", "--", "bundle", "exec", "ruby", "app.rb"]