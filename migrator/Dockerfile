ARG MIGRATOR_PHP_VERSION
from welaika/wordmove:php${MIGRATOR_PHP_VERSION}

# Avoid error(invalid byte sequence in US-ASCII (ArgumentError)) when pulling database.
ENV RUBYOPT='--encoding=UTF-8'

# Start ssh-agent not to be double startup.
RUN { \
  echo 'SSH_AGENT_FILE=${HOME}/.ssh-agent'; \
  echo 'if [ ! -f ${SSH_AGENT_FILE} ]; then'; \
  echo '  ssh-agent > ${SSH_AGENT_FILE}'; \
  echo 'fi'; \
  echo 'source ${SSH_AGENT_FILE}'; \
} >> /root/.bashrc
