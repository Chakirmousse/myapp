# Utilisation d'une image de base plus petite et configuration du cache NuGet
FROM mcr.microsoft.com/dotnet/sdk-alpine:8.0 AS build
WORKDIR /app
COPY . .
COPY nuget.config nuget.config
RUN dotnet restore

# Construction et publication
RUN dotnet build --configuration Release && dotnet publish --configuration Release --output /app/publish

# Utilisation de l'image runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_ENVIRONMENT=Production
ENTRYPOINT ["dotnet", "Demo1.Api.dll"]