FROM google/dart:2.2 as dart2
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
# Use pub from Dart 2 to initially resolve dependencies since it is much more efficient.
COPY --from=dart2 /usr/lib/dart /usr/lib/dart2
RUN echo "Running Dart 2 pub get.." && \
	_PUB_TEST_SDK_VERSION=2.4.1 timeout 5m /usr/lib/dart2/bin/pub get --no-precompile
RUN echo "Starting the script sections" && \
		dart --version && \
		pub get && \
		pub run dart_dev analyze && \
		pub run dependency_validator -i coverage,build_runner,build_test,build_web_compilers
RUN echo "Running tests" && \
        pub run dart_dev test && \
		echo "Done running tests"
ARG BUILD_ARTIFACTS_AUDIT=/build/pubspec.lock
ARG BUILD_ARTIFACTS_BUILD=/build/pubspec.lock
ARG BUILD_ARTIFACTS_DART-DEPENDENCIES=/build/pubspec.lock
FROM scratch
