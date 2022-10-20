FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["PharmaMgmt.csproj", "."]
RUN dotnet restore "./PharmaMgmt.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "PharmaMgmt.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PharmaMgmt.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PharmaMgmt.dll"]