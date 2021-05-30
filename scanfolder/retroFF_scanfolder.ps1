#*=============================================================================
#* INITIALISE VARIABLES
#*=============================================================================

$ffOutContainer = ".mxf"

$input_containers =
"*.mxf",
"*.mp4",
"*.3gp",
"*.3g2",
"*.avi",
"*.f4v",
"*.flv",
"*.mkv",
"*.mpg",
"*.mpeg",
"*.ts",
"*.ogg",
"*.mov",
"*.qt"

$logFile = "..\..\tests\logs.txt"
$folderInputPath = "..\..\tests"
$folderOutputPath = "..\..\tests\transcoded"
$folderDonePath = "..\..\tests\done"
$fileInputName = ""

$SLEEPTIME = 5

#*=============================================================================
#* FUNCTION LISTINGS
#*=============================================================================

function CheckOpen {
    param ([string] $currentFile)
    $path = "$folderInputPath\$currentFile" 
    $isOpen = 0

    try {
        $file = [System.io.File]::Open($path, "Open", "Read", "None")
        $reader = New-Object System.IO.StreamReader($file)
        $reader.ReadLine()
        $reader.Close()
        $file.Close()
    }
    catch [Exception] {
        $isOpen = 1
    }

    return $isOpen
}

function ProcessFolder {
    $first_sleep = $True
    $currentFileIndex = 0
    while ($True) {
        $childItems = @(Get-ChildItem -Path $folderInputPath -Include $input_containers -Name)
        $currentFile = $childItems[$currentFileIndex]

        if (!$currentFile) {
            if ($first_sleep) {
                Write-Output ">>>>>>>>>> No new clips found... Sleeping $SLEEPTIME seconds "
                $first_sleep = $False
            }
            Start-Sleep $SLEEPTIME

        }
        elseif ((CheckOpen $currentFile) -eq 1) {
            $currentFileIndex += 1
            if ($childItems.count -le $currentFileIndex) {
                $currentFileIndex = 0
            }
            Write-Output ">>>>>>>>>> New clip(s) found... Growing file: $currentFile"
            Start-Sleep $SLEEPTIME
            
        }
        else {
            $first_sleep = $True
            $fileInputName = $currentFile.split(".")[0]
            $fileInput = "$folderInputPath\$currentFile" 
            $fileOutput = "$folderOutputPath\$fileInputName$ffOutContainer"
            $fileDone = "$folderDonePath\$currentFile"
            
            Transcode $fileInput $fileOutput
            Move-Item -Path $fileInput -Destination $fileDone -Force
        }
    }
}

function Transcode {
    param ([string] $fileInput, $fileOutput)
    
    Remove-Item -Path $fileOutput -ErrorAction Ignore

    Write-Output ">>>>>>>>>> Starting transcode... $fileInput"

    ffmpeg -n -i $fileInput -map 0:v -map 0:a:0? -map 0:a:1? -map 0:a:2? -map 0:a:3? -map 0:a:4? -map 0:a:5? -map 0:a:6? -map 0:a:7? -c:v dnxhd -vf "scale=1920:1080,fps=25,format=yuv422p" -b:v 120M -flags +ildct -ar 48000 -c:a pcm_s24le $fileOutput
    
    if ($LastExitCode) {
        Write-Output ">>>>>>>>>> Transcode failed. File: $fileInput"
    }
    else {
        Write-Output ">>>>>>>>>> Transcode succesful"
    }
    Write-Output ""
}

#*=============================================================================
#* SCRIPT BODY
#*=============================================================================

Start-Transcript -Path $logFile -Append

New-Item -ItemType Directory -Force -Path $folderDonePath | Out-Null
ProcessFolder

#*=============================================================================
#* END OF SCRIPT
#*=============================================================================
