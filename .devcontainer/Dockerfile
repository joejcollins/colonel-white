# Sourcery and gcsfuse won't run on `arm` so force the use of `amd64` for the base image.
FROM --platform=linux/amd64 mcr.microsoft.com/devcontainers/python:1-3.12-bullseye AS base

# Install uv for everyone not just the current user.
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
 && cp /root/.local/bin/uv /usr/local/bin/uv

# Install LaTeX.
RUN apt-get --quiet update \
 && apt-get install --assume-yes texlive latexmk \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Add some labels so it looks nice in Github packages.
LABEL org.opencontainers.image.source=https://github.com/earthroverprogram/helheim
LABEL org.opencontainers.image.description="helheim image."
