ARG BASE_VERSION
ARG NODE_VERSION
FROM ghcr.io/base2services/dotnet7x:${BASE_VERSION}
ARG NODE_VERSION
RUN apt update && apt install zip -y && rm -rf /var/lib/apt/lists/*
RUN dotnet tool install -g Amazon.Lambda.Tools
RUN npm install -g n
RUN n ${NODE_VERSION}
RUN npm install -g yarn

ENV PATH="$PATH:/root/.dotnet/tools"