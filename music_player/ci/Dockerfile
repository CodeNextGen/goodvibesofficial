FROM google/dart:2.1

# Set language to support UTF-8
ENV LANG C.UTF-8

ENV PATH $PATH:~/.pub-cache/bin

ENV FLUTTER_VERSION v1.2.1

# Install required packages
RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install libglu1-mesa lib32stdc++6 unzip git && \
  rm -rf /var/lib/apt/lists/* && \
  # Get the flutter SDK at version FLUTTER_VERSION and
  # avoid downloading git history with --depth 1
  git clone --branch ${FLUTTER_VERSION} --depth 1 https://github.com/flutter/flutter.git

ENV PATH $PATH:/flutter/bin

COPY pubspec.yaml /root/pubspec.yaml
COPY pubspec.lock /root/pubspec.lock

WORKDIR /root/

RUN flutter packages get

RUN pub global activate grinder
