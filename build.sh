#!/usr/bin/env sh
#######################################################################
# Build, test and push the images
# Creates multiple versions so that there's some choice about versions
# to use
#######################################################################
set -eux

# Number of releases to go back from the latest version
number_of_travis_releases=3
number_of_ruby_releases=3

# Creates tags of the form {TRAVIS_VERSION}-ruby{RUBY_VERSION} (e.g. 1.8.11-ruby2.7.0-alpine3.11)
# First gets the last $number_of_ruby_releases ruby tags where the tag looks like a version number (there were some odd tags that look like dates)
# For each of those tags gets the last $number_of_travis_releases of non-release candidate versions of travis and builds an image
docker run leonyork/docker-tags library/ruby \
    | grep -E '^[0-9.]+-alpine[0-9.]+$' \
    | tail -n $number_of_ruby_releases \
    | xargs -I{RUBY_VERSION} -n1 \
        sh -c "docker run leonyork/ruby-gem-versions travis \
        | grep -E '^[0-9.]\.[0-9.]+$' \
        | head -n $number_of_travis_releases \
        | xargs -I{TRAVIS_VERSION} -n1 sh build-image.sh {RUBY_VERSION} {TRAVIS_VERSION} {TRAVIS_VERSION}-ruby{RUBY_VERSION} || exit 255" || exit 255

ruby_latest_version=`docker run leonyork/docker-tags library/ruby | grep -E '^[0-9.]+-alpine[0-9.]+$' | tail -n 1`
# Creates tags of the form {TRAVIS_VERSION} (e.g. 1.8.11)
# Gets the last $number_of_travis_releases of non-release candidate versions of travis and creates an image using the latest ruby image
docker run leonyork/ruby-gem-versions travis \
        | grep -E '^[0-9.]\.[0-9.]+$' \
        | head -n $number_of_travis_releases \
        | xargs -I{TRAVIS_VERSION} -n1 sh build-image.sh $ruby_latest_version {TRAVIS_VERSION} {TRAVIS_VERSION} || exit 255

# Generates the latest tag
travis_latest_version=`docker run leonyork/ruby-gem-versions travis | head -n 1`
sh build-image.sh $ruby_latest_version $travis_latest_version latest