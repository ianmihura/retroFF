###################################################################################################
##                                                                                               ##
#                                        RETROFF ULTIMATE                                         #
#             El script transocdifica media con varias instancias de ffmpeg paralelas             #
#                                     - Superusers Mediapro -                                     #
##                                                                                               ##
###################################################################################################

<#
.SYNOPSIS
    The script transcodes media with paralel instances of ffmpeg
.DESCRIPTION
    Settings defined in settings.json, will look for this file in the app home directory
    The script will be packaged with its settings in Program Files,
    And environmental variable PATH will be edited to that the script runs universally 
    If the home directory is changed, be sure to change the PATH variable
.EXAMPLE
    C:\PS> retroFF.ps1 -folder "C:\test"
        <Transcodes full folder contents into C:\test\transcoded>
    C:\PS> retroFF.ps1 -file "C:\test\test_video.mxf"
        <Transcodes file into C:\test\transcoded>
    C:\PS> retroFF.ps1 -file "C:\test\test_video.mxf" -log
        <Transcodes file into C:\test\transcoded, and leaves logs in C:\test\logs>
    C:\PS> retroFF.ps1 -file "C:\test\test_video.mxf" -settings
        <Transcodes file into C:\test\transcoded, and leaves logs in C:\test\logs>
.NOTES
    Authors: Pablo Mongay, Ian Mihura
#>


#*=============================================================================
#* PARAMETER DECLARATION
#*=============================================================================


param (
    [string] $homedir = "C:\Program Files\RetroFF Ultimate",
    [string] $file, 
    [string] $folder, 
    [switch] $log = $False, 
    [string] $preset = "h264", 
    [switch] $config = $False )


#*=============================================================================
#* INITIALISE VARIABLES
#*=============================================================================

$settingsDir = "$homedir\settings.json"

Try {
    $settings = Get-Content $settingsDir | ConvertFrom-Json -ErrorAction stop
}
Catch {
    Write-Host "Cannot read settings file"
    Pause
    return
}

$ffOptions = $settings.preset.$preset.options
$ffOutContainer = $settings.preset.$preset.container

$input_containers = $settings.array.input_containers

$max_instances = $settings.string.max_instances
$overwrite = $settings.bool.overwrite
$log = $log -or $settings.bool.log

$folderOutputName = $settings.string.folder_output
$folderOutputLogsName = $settings.string.folder_output_logs
$folderOutputPath = ""
$folderOutputLogsPath = ""
$folderInputPath = ""

$SLEEPTIME = 1
$firstTime = $True


#*=============================================================================
#* FUNCTION LISTINGS
#*=============================================================================

function Main {
    Write-Host `nBienvenido a RETROFF`n 
    
    if ($file) { $folderInputPath = Split-Path $file }
    elseif ($folder) { $folderInputPath = $folder }
    else { $folderInputPath = $PSScriptRoot }
    
    if ($log) {
        $folderOutputLogsPath = $folderInputPath + $folderOutputLogsName 
        CreateFolder $folderOutputLogsPath
    }
    
    $folderOutputPath = $folderInputPath + $folderOutputName
    CreateFolder $folderOutputPath
    
    if ($file) { ProcessFile }
    else { ProcessFolder }
}

function ProcessFile {
    $fileInputName = (Split-Path $file -Leaf).split(".")[0]
    $fileOutput = "$folderOutputPath\$fileInputName$ffOutContainer"
    $logFile = "$folderOutputLogsPath\$($fileInputName)_log.txt" 

    Transcode $file $fileOutput $logFile
}

function ProcessFolder {
    Write-Host $max_instances
    Get-ChildItem -Path $folderInputPath -Include $input_containers -Name | ForEach-Object {
        if (!$firstTime) {
            while ((Get-Process -Name ffmpeg | Measure-Object | Select-Object -ExpandProperty Count) -ge $max_instances) { 
                Start-Sleep $SLEEPTIME 
            }
        }
    
        $firstTime = $False
        
        $fileInputName = $_.split(".")[0]
        $fileInput = "$folderInputPath\$_" 
        $fileOutput = "$folderOutputPath\$fileInputName$ffOutContainer"
        $logFile = "$folderOutputLogsPath\$($fileInputName)_log.txt" 
    
        Transcode $fileInput $fileOutput $logFile
    }
}

function CreateFolder {
    param ([string] $folderName)
    New-Item -ItemType Directory -Force -Path $folderName | Out-Null
}

function Transcode {
    param ([string] $fileInput, $fileOutput, $logFile)
    
    if ($overwrite) { Remove-Item -Path $fileOutput -ErrorAction Ignore }

    $ffmpegArgs = " -n -i `"$fileInput`" $ffOptions `"$fileOutput`""

    Write-Host "Intentando codificar... $_"

    if ($log) { Start-Process -FilePath ffmpeg -ArgumentList $ffmpegArgs -RedirectStandardError $logFile }
    else { Start-Process -FilePath ffmpeg -ArgumentList $ffmpegArgs }
}

 
#*=============================================================================
#* SCRIPT BODY
#*=============================================================================

if ($config) {
    try {
        Write-Host "Opening settings..."
        & $homedir\settings.exe -settings $settingsDir
    }
    catch {
        Write-Host "Error while trying to open settings"
    }
} 
elseif (!$ffOptions) {
    Write-Host "Preset $preset not found"
}
else {
    Main
}

Pause

#*=============================================================================
#* END OF SCRIPT
#*=============================================================================
