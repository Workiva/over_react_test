FROM drydock-prod.workiva.net/workiva/smithy-runner-generator:355624 as build

# Build Environment Vars
ARG BUILD_ID
ARG BUILD_NUMBER
ARG BUILD_URL
ARG GIT_COMMIT
ARG GIT_BRANCH
ARG GIT_TAG
ARG GIT_COMMIT_RANGE
ARG GIT_HEAD_URL
ARG GIT_MERGE_HEAD
ARG GIT_MERGE_BRANCH
# Expose env vars for git ssh access
ARG GIT_SSH_KEY
ARG KNOWN_HOSTS_CONTENT
# Install SSH keys for git ssh access
RUN mkdir /root/.ssh
RUN echo "$KNOWN_HOSTS_CONTENT" > "/root/.ssh/known_hosts"
RUN echo "$GIT_SSH_KEY" > "/root/.ssh/id_rsa"
RUN chmod 700 /root/.ssh/
RUN chmod 600 /root/.ssh/id_rsa
RUN echo "Setting up ssh-agent for git-based dependencies"
RUN eval "$(ssh-agent -s)" && \
	ssh-add /root/.ssh/id_rsa
ENV DARTIUM_EXPIRATION_TIME=1577836800
WORKDIR /build/
ADD . /build/
RUN echo "Starting the script sections" && \
		dart --version && \
		pub get && \
        pub run dependency_validator -i coverage && \
		echo "Script sections completed"
ARG BUILD_ARTIFACTS_AUDIT=/build/pubspec.lock
ARG BUILD_ARTIFACTS_BUILD=/build/pubspec.lock
ARG BUILD_ARTIFACTS_DART-DEPENDENCIES=/build/pubspec.lock
FROM scratch
