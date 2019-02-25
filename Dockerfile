FROM jruby:9.1-alpine as logstash-filter-de_dot

ENV LOGSTASH_BRANCH=v6.5.1

RUN java -Xmx32m -version

RUN gem install bundler -v '< 2'

RUN apk add --no-cache \
      openjdk8 \
      git

RUN mkdir logstash-filter-de_dot

ADD Gemfile Rakefile *.gemspec logstash-filter-de_dot/
ADD ci logstash-filter-de_dot/ci/
ADD lib logstash-filter-de_dot/lib/
ADD spec logstash-filter-de_dot/ci/spec/

WORKDIR logstash-filter-de_dot

RUN source ./ci/setup.sh && \
    bundle update && \
    bundle install && \
    truncate -s 0 /logstash/logstash-core/lib/logstash/patches/resolv.rb && \
    bundle exec rake vendor && \
    bundle exec rspec spec && \
    bundle exec gem build logstash-filter-de_dot.gemspec

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
