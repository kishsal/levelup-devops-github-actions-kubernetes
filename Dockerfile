#build server
FROM mcr.microsoft.com/dotnet/sdk:3.1-alpine as build

WORKDIR /src

COPY levelup-devops-github-actions-kubernetes.csproj .
RUN dotnet restore


COPY . .
RUN dotnet build -c Release
RUN dotnet test
RUN dotnet publish -c Release -o /dist


#production server
FROM mcr.microsoft.com/dotnet/aspnet:3.1-alpine

WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS http://+:80
EXPOSE 80

COPY --from=build /dist .

CMD ["dotnet", "levelup-devops-github-actions-kubernetes.dll"]

