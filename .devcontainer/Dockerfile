FROM google/dart:2.9-dev


# The image includes a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscodei
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set to false to skip installing zsh and Oh My ZSH!
ARG INSTALL_ZSH="true"

# Location and expected SHA for common setup script - SHA generated on release
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/v0.112.0/script-library/common-debian.sh"
ARG COMMON_SCRIPT_SHA="28e3d552a08e0d82935ad7335837f354809bec9856a3e0c2855f17bfe3a19523"

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Dart Dev Channel
ENV DART_VERSION 2.9.0-15.0.dev
ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:/root/.pub-cache/bin:$PATH

# Add user: https://github.com/nodejs/docker-node/blob/2caaf1a42cdf44e0e50ab30c82415c71bf2f3a21/Dockerfile-slim.template#L3
RUN groupadd --gid 1000 vscodei \
    && useradd --uid 1000 --gid vscodei --shell /bin/bash --create-home vscodei

# gnupg2: https://stackoverflow.com/questions/50757647
RUN apt-get update \
    && apt-get --no-install-recommends --yes install \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    dialog \
    git \
    gnupg2 \
    openssh-client \
    wget \
    zsh \
    #
    # Verify git, common tools / libs installed, add/modify non-root user, optionally install zsh
    && wget -q -O /tmp/common-setup.sh $COMMON_SCRIPT_SOURCE \
    && ( if [ "$COMMON_SCRIPT_SHA" != "dev-mode" ]; then echo "$COMMON_SCRIPT_SHA /tmp/common-setup.sh" | sha256sum -c - ; fi ) \
    && /bin/bash /tmp/common-setup.sh "$INSTALL_ZSH" "$USERNAME" "$USER_UID" "$USER_GID" \
    && rm /tmp/common-setup.sh \
    #
    # Install dart
    && curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list \
    && curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_testing.list > /etc/apt/sources.list.d/dart_testing.list \
    && curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list \
    && apt-get update \
    && apt-get install dart=$DART_VERSION-1 \
    #
    # Set dart install location that both users have rights to access
    && mkdir -p $DART_SDK/bin \
    && mkdir -p /root/.pub-cache/bin \
    && chown ${USERNAME}:root $DART_SDK/bin \
    && chown ${USERNAME}:root /root/.pub-cache/bin \
    #
    # Tactically remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    # Can leave in Dockerfile once upstream base image moves to > 7.0.7-28.
    && apt-get purge --yes imagemagick imagemagick-6-common \
    #
    # Cleanup
    && apt-get autoremove --yes \
    && apt-get clean --yes \
    && rm -rf /var/lib/apt/lists/*

# https://github.com/microsoft/vscode-remote-try-node/blob/master/.devcontainer/Dockerfile
# [Optional] Update UID/GID if needed
RUN if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then \
    groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME; \
    fi

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
