#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM google/dart:2.9-dev

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Add bin location to path
ENV PATH="$PATH":"/root/.pub-cache/bin"

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
    apt-utils dialog 2>&1 \
    #
    # Verify git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt-get install --yes --no-install-recommends \
    git openssh-client less iproute2 procps lsb-release \
    #
    # Install other dependencies
    && apt-get install --yes --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    vim \
    wget \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --shell /bin/bash --uid $USER_UID --gid $USER_GID --create-home $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install --yes --no-install-recommends sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Install Zsh
    && apt-get install --yes --no-install-recommends zsh \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && echo "export PATH=\$PATH:\$HOME/.local/bin" | tee -a /root/.zshrc \
    && cp -R /root/.oh-my-zsh /home/$USERNAME \
    && cp /root/.zshrc /home/$USERNAME \
    && sed -i -e "s/\/root\/.oh-my-zsh/\/home\/$USERNAME\/.oh-my-zsh/g" /home/$USERNAME/.zshrc \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME/.oh-my-zsh /home/$USERNAME/.zshrc \
    #
    # # Install LazyGit
    # && apt-get install --yes --no-install-recommends software-properties-common \
    # # W: GPG error: http://ppa.launchpad.net/lazygit-team/release/ubuntu bionic InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 68CCF87596E97291
    # # E: The repository 'http://ppa.launchpad.net/lazygit-team/release/ubuntu bionic InRelease' is not signed.
    # && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68CCF87596E97291 \
    # && add-apt-repository "deb http://ppa.launchpad.net/lazygit-team/release/ubuntu bionic main" \
    # && apt-get update \
    # && apt-get install --yes --no-install-recommends lazygit \
    #
    # Tactically remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    # Can leave in Dockerfile once upstream base image moves to > 7.0.7-28.
    && apt-get purge --yes imagemagick imagemagick-6-common \
    #
    # Clean up
    && apt-get autoremove --yes \
    && apt-get clean --yes \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
