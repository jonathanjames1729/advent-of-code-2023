FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-3-bullseye

COPY 'netskope.crt' '/usr/local/share/ca-certificates/netskope.crt'
COPY 'goskope.crt' '/usr/local/share/ca-certificates/goskope.crt'
RUN update-ca-certificates
ENV NODE_EXTRA_CA_CERTS='/etc/ssl/certs/ca-certificates.crt'

RUN mkdir -p /home/vscode/.local/bin && \
    chown -R vscode:vscode /home/vscode
COPY --chown=vscode:vscode setup.sh /home/vscode/.local/bin/setup
RUN chmod +x /home/vscode/.local/bin/setup
