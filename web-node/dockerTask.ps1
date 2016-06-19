<#
.SYNOPSIS
Builds and runs a Docker image.
.PARAMETER Compose
Runs docker-compose.
.PARAMETER Build
Builds a Docker image.
.PARAMETER Clean
Removes the image stevelasker/web-node and kills all containers based on that image.
.PARAMETER ComposeForDebug
Builds the image and runs docker-compose.
.PARAMETER Environment
The enviorment to build for (Debug or Release), defaults to Debug
.EXAMPLE
C:\PS> .\dockerTask.ps1 -Build
Build a Docker image named stevelasker/web-node
#>

Param(
    [Parameter(Mandatory=$True,ParameterSetName="Compose")]
    [switch]$Compose,
    [Parameter(Mandatory=$True,ParameterSetName="ComposeForDebug")]
    [switch]$ComposeForDebug,
    [Parameter(Mandatory=$True,ParameterSetName="Build")]
    [switch]$Build,
    [Parameter(Mandatory=$True,ParameterSetName="Clean")]
    [switch]$Clean,
    [parameter(ParameterSetName="Compose")]
    [Parameter(ParameterSetName="ComposeForDebug")]
    [parameter(ParameterSetName="Build")]
    [ValidateNotNullOrEmpty()]
    [String]$Environment = "Debug"
)

$imageName="stevelasker/web-node"
$projectName="webnode"
$publicPort=3000
$isWebProject=$true
$url="http://docker:$publicPort"

# Kills all running containers of an image and then removes them.
function CleanAll () {
    # List all running containers that use $imageName, kill them and then remove them.
    docker ps -a | select-string -pattern $imageName | foreach { $containerId =  $_.ToString().split()[0]; docker kill $containerId *>&1 | Out-Null; docker rm $containerId *>&1 | Out-Null }
}

# Builds the Docker image.
function BuildImage () {
    $dockerFileName = "Dockerfile"
    $taggedImageName = $imageName
    if ($Environment -ne "Release") {
        $dockerFileName = "Dockerfile.$Environment"
        $taggedImageName = "${imageName}:$Environment".ToLowerInvariant()
    }

    if (Test-Path $dockerFileName) {
        Write-Host "Building the image $imageName ($Environment)."
        docker build -f $dockerFileName -t $taggedImageName .
    }
    else {
        Write-Error -Message "$Environment is not a valid parameter. File '$dockerFileName' does not exist." -Category InvalidArgument
    }
}

# Runs docker-compose.
function Compose () {
    $composeFileName = "docker-compose.yml"
    if ($Environment -ne "Release") {
        $composeFileName = "docker-compose.$Environment.yml"
    }

    if (Test-Path $composeFileName) {
        Write-Host "Running compose file $composeFileName"
        docker-compose -f $composeFileName -p $projectName kill
        docker-compose -f $composeFileName -p $projectName up -d
    }
    else {
        Write-Error -Message "$Environment is not a valid parameter. File '$dockerFileName' does not exist." -Category InvalidArgument
    }
}

# Opens the remote site
function OpenSite () {
    Write-Host "Opening site" -NoNewline
    $status = 0

    #Check if the site is available
    while($status -ne 200) {
        try {
            $response = Invoke-WebRequest -Uri $url -Headers @{"Cache-Control"="no-cache";"Pragma"="no-cache"} -UseBasicParsing
            $status = [int]$response.StatusCode
        }
        catch [System.Net.WebException] { }
        if($status -ne 200) {
            Write-Host "." -NoNewline
            Start-Sleep 1
        }
    }

    Write-Host
    # Open the site.
    Start-Process $url
}

# Call the correct function for the parameter that was used
if($Compose) {
    Compose
    if ($isWebProject) {
        OpenSite
    }
}
elseif($ComposeForDebug) {
    $env:REMOTE_DEBUGGING = 1
    BuildImage
    Compose
}
elseif($Build) {
    BuildImage
}
elseif ($Clean) {
    CleanAll
}