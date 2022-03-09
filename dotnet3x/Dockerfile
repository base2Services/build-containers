ARG BASE_VERSION
FROM mcr.microsoft.com/dotnet/core/sdk:${BASE_VERSION}
RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*