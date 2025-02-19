

param (
    [string]$dir_path
)

if (-Not (Test-Path -Path $dir_path -PathType Container)) {
    Write-Host "not a valid path"
    exit
}

$sub_directories = Get-ChildItem -Path $dir_path -Directory

Set-Location -Path "C:\\Users\\admin\\source\\repos\\OFIQ-Project-FGFP\\install_x86_64\\Release\\bin"


$max_processes = 1
$process_count = 0

function Get-RunningProcesses {
    return (Get-Process -Name "OFIQSampleApp" -ErrorAction SilentlyContinue).Count
}

foreach ($sub_dir in $sub_directories) {
    Write-Host "Directory reached: $($sub_dir.FullName)"
    $ofiq_command = ".\\OFIQSampleApp"
    
    # # Compute UQS and CQMs
    # $arguments = @(
    #     "-c ..\\..\\..\\data\\"
    #     "-i $($sub_dir.FullName)"
    #     "-o .\score_files\$($sub_dir.Name)-scores.csv"
    # )

    # Compute only UQS
    $arguments = @(
        "-c ..\\..\\..\\data\\ofiq_config_UQS_only.jaxn"
        "-i $($sub_dir.FullName)"
        "-o .\score_files\$($sub_dir.Name)-Existing-Regions-blackout-UQS-scores.csv"
    )

    $running_processes_count = Get-RunningProcesses

    while (-Not ($running_processes_count -lt $max_processes)) {
        Start-Sleep -Seconds 5
        $running_processes_count = Get-RunningProcesses
    }
    
    Start-Process -FilePath $ofiq_command -ArgumentList $arguments

    $process_count++
    Write-Output "Started process #$process_count. Total running: $($running_processes_count + 1)"
}
