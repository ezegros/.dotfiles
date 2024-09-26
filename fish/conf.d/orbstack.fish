set -x DOCKER_HOST unix://{$HOME}/.orbstack/run/docker.sock

# Workaround for testcontainers
set -x TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE /var/run/docker.sock
