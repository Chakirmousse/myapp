# Étape 1 : Utiliser l'image officielle de .NET SDK pour la construction
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Définir le répertoire de travail dans l'image
WORKDIR /app

# Copier les fichiers de votre solution dans le conteneur
COPY . ./

# Restaurer les dépendances en utilisant le bon nom de fichier
RUN dotnet restore Demo1.sln.sln

# Compiler l'application en mode Release
RUN dotnet build Demo1.sln.sln -c Release -o /app/build

# Étape 2 : Utiliser l'image de runtime de .NET pour exécuter l'application
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app

# Copier les fichiers de l'étape de build
COPY --from=build /app/build .

# Définir le point d'entrée (exécution de l'application)
ENTRYPOINT ["dotnet", "Demo1.Api.dll"]

# Exposer le port 80
EXPOSE 80
