FROM ruby:3.3

# Force Bundler à installer les gems dans le dossier système global de Ruby
ENV GEM_HOME="/usr/local/bundle"
ENV PATH="${GEM_HOME}/bin:${PATH}"

WORKDIR /app

COPY Gemfile ./
# On s'assure d'installer explicitement la version verrouillée
RUN bundle install

COPY . .

EXPOSE 4567

CMD ["bundle", "exec", "rerun", "ruby", "app.rb"]