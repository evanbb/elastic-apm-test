# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY *.csproj .
RUN dotnet restore

# copy everything else and build app
COPY . .
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /app ./
COPY ./ElasticApmAgent_1.7.0 /ElasticApmAgent_1.7.0

ENV DOTNET_STARTUP_HOOKS=/ElasticApmAgent_1.7.0/ElasticApmAgentStartupHook.dll
ENV ELASTIC_APM_SERVER_URLS=https://3d9e391067624afea92b087242d4f69f.apm.eastus2.azure.elastic-cloud.com
ENV ELASTIC_APM_SECRET_TOKEN=pAIyh3dFI1ktF1x7BL
ENV ELASTIC_APM_SERVICE_NAME=ElasticApmTestApi
ENV ELASTIC_APM_STARTUP_HOOKS_LOGGING=1
ENV ELASTIC_APM_LOG_LEVEL=trace

ENTRYPOINT ["dotnet", "Elastic.Apm.Test.Api.dll"]
