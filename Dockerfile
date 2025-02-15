FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN mkdir /workspace
WORKDIR /workspace

RUN  cd /workspace && \
  uv init && \
  uv venv && \
  . .venv/bin/activate && \
  uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# hadolint ignore=DL3008
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
  # tools & required packages
  git curl wget ca-certificates fish \
  # clean up
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ARG VERSION="1.96.4"
# ENV TUNNEL_ID="nosana.asse"
# ENV TUNNEL_TOKEN="eyJhbGciOiJFUzI1NiIsImtpZCI6IkZCM0U2NTMwNjlDQ0I5MUFCQUUxRTNFQjk1RDc5NzdERDQxODM1QjYiLCJ0eXAiOiJKV1QifQ.eyJjbHVzdGVySWQiOiJhc3NlIiwidHVubmVsSWQiOiJ0aWR5LWJvb2stdGJ4MG0ybSIsInNjcCI6ImNvbm5lY3QgbWFuYWdlIGhvc3QiLCJleHAiOjE3Mzg5ODE3NTMsImlzcyI6Imh0dHBzOi8vdHVubmVscy5hcGkudmlzdWFsc3R1ZGlvLmNvbS8iLCJuYmYiOjE3Mzg4OTQ0NTN9.1kjyDpEZT9okONEIQsxH3ERoL65T43mqmC8Mmr-i5vaolL2pU12OIn2mOfmrEaSz1eEB1rWtePPjPezag1ziPQ"
# ENV TUNNEL_NAME="nosana"


RUN wget -qO- https://update.code.visualstudio.com/${VERSION}/cli-linux-x64/stable | tar xvz -C /usr/bin/

ENTRYPOINT ["code", "tunnel", "--accept-server-license-terms"]
# CMD ["--tunnel-id", "${TUNNEL_ID}", "--host-token", "${TUNNEL_TOKEN}", "--name", "${TUNNEL_NAME}"]

# ENTRYPOINT [ "/bin/bash" ]

HEALTHCHECK NONE

# expose port
EXPOSE 8000
