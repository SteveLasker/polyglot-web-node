echo docker rm -f $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
echo docker rmi -f $(docker images -q)
docker rmi -f $(docker images -q)
echo docker pull node
docker pull node
echo docker pull microsoft/dotnet:1.0.0-rc2-core
docker pull microsoft/dotnet:1.0.0-rc2-core
echo docker pull microsoft/dotnet:1.0.0-preview1
docker pull microsoft/dotnet:1.0.0-preview1