ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}
ARG TRAVIS_VERSION
RUN apk add --no-cache build-base && \
    gem install travis -v ${TRAVIS_VERSION} && \
    apk del build-base
ENTRYPOINT ["travis"]
CMD ["help"]