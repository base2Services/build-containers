ARG BASE_VERSION
FROM mcr.microsoft.com/dotnet/core/sdk:${BASE_VERSION}

LABEL org.opencontainers.image.source = 'https://github.com/base2Services/build-containers/dotnet3x'

RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*
