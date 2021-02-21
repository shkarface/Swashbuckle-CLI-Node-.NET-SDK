ARG NET_VERSION

FROM mcr.microsoft.com/dotnet/sdk:$NET_VERSION AS dotnet-node

ARG NET_VERSION
ARG NODE_VERSION
LABEL node="${NODE_VERSION}"
LABEL dotnet="${NET_VERSION}"

RUN curl -sL https://deb.nodesource.com/setup_"$NODE_VERSION" | bash -
RUN apt-get install -y nodejs
RUN npm install -g minify-json

FROM dotnet-node AS swashbuckle-cli

ARG SWASHBUCKLE_VERSION

LABEL swashbuckle="${SWASHBUCKLE_VERSION}"

RUN dotnet tool install Swashbuckle.AspNetCore.Cli \
    --tool-path /tools \
    --version $SWASHBUCKLE_VERSION
