FROM quay.io/podman/stable

# Update and download dependencies
RUN yum install -y curl jq wget podman-docker

# Directory for runner to operate in
RUN mkdir ./actions-runner
WORKDIR /home/actions-runner

# Download Actions runner
# https://github.com/terraform-google-modules/terraform-google-github-actions-runners/blob/598a38a72b7bbaf56be431c07de04752c521fd60/examples/gh-runner-gke-dind/Dockerfile#L28-L31
ARG GH_RUNNER_VERSION="2.273.0"
RUN curl -o actions.tar.gz --location "https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz" && \
    tar -zxf actions.tar.gz && \
    rm -f actions.tar.gz

# Install dependencies
RUN ./bin/installdependencies.sh

# Allow runner to run as root
ENV RUNNER_ALLOW_RUNASROOT=1

COPY startup.sh .

ENTRYPOINT ["./startup.sh"]
