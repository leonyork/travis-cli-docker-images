# Travis CLI Docker images

Images for running [the Travis CLI](https://github.com/travis-ci/travis.rb).

## Build

```docker build --build-arg RUBY_VERSION=2.7.0-alpine3.11 --build-arg TRAVIS_VERSION=1.8.11 -t leonyork/travis .```

## Test

```docker run leonyork/travis --version```