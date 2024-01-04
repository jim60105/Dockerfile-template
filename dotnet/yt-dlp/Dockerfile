#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

### Base image for yt-dlp
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-alpine AS base
WORKDIR /app

RUN apk add --no-cache aria2 ffmpeg python3 && \
    apk add --no-cache --virtual build-deps musl-dev gcc g++ python3-dev py3-pip && \
    python3 -m venv /venv && \
    source /venv/bin/activate && \
    pip install --no-cache-dir yt-dlp && \
    pip uninstall -y setuptools pip && \
    apk del build-deps

ENV AZURE_STORAGE_CONNECTION_STRING_VTUBER="ChangeThis"
ENV CHANNELS_IN_ARRAY="[\"https://www.youtube.com/channel/UCBC7vYFNQoGPupe5NxPG4Bw\"]"
ENV MAX_DOWNLOAD="10"
ENV DATE_BEFORE="2"
ENV PATH="/venv/bin:$PATH"

### Debug image
FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine AS debug
WORKDIR /app

RUN apk add --no-cache aria2 ffmpeg python3 && \
    apk add --no-cache --virtual build-deps musl-dev gcc g++ python3-dev py3-pip && \
    python3 -m venv /venv && \
    source /venv/bin/activate && \
    pip install --no-cache-dir yt-dlp && \
    pip uninstall -y setuptools pip && \
    apk del build-deps
ENV PATH="/venv/bin:$PATH"

### Build .NET
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
ARG BUILD_CONFIGURATION=Release
ARG TARGETARCH
WORKDIR /src

COPY ["backup-dl.csproj", "."]
RUN dotnet restore -a $TARGETARCH "backup-dl.csproj"

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
COPY . .
RUN dotnet publish "backup-dl.csproj" -a $TARGETARCH -c $BUILD_CONFIGURATION -o /app/publish --self-contained true

### Final image
FROM base AS final

ENV PATH="/app:$PATH"

RUN mkdir -p /app && chown -R $APP_UID:$APP_UID /app && chmod u+rwx /app
COPY --from=publish --chown=$APP_UID:$APP_UID /app/publish/backup-dl /app/backup-dl

USER $APP_UID

ENTRYPOINT ["/app/backup-dl"]