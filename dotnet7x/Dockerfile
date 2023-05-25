ARG BASE_VERSION
FROM  mcr.microsoft.com/dotnet/sdk:${BASE_VERSION}

LABEL org.opencontainers.image.source = 'https://github.com/base2Services/build-containers/dotnet7x'

RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*
