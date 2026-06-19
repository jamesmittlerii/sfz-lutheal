# Define paths
$sourceBase = "E:\users\chica\downloads\LuthCimbalom\Cimbalom (All Stops)\Release\Pedal Noise"
$destDir = "E:\Users\chica\downloads\dummy\Luthéal Piano - Cimbalom Pedal Noise"

# Ensure destination exists
if (!(Test-Path $destDir)) {
    New-Item -ItemType Directory -Force -Path $destDir
}

# Get all WAV files from Pedal Push and Pedal Release specifically
$pedalFiles = Get-ChildItem -Path $sourceBase -Filter *.wav -Recurse

Write-Host "Found $($pedalFiles.Count) Pedal Noise WAV files." -ForegroundColor Cyan

foreach ($file in $pedalFiles) {
    # Determine the target filename
    $targetName = $file.Name -replace '\.wav$', '.flac'
    $targetPath = Join-Path $destDir $targetName

    if (Test-Path $targetPath) {
        Write-Host "Skipping: $targetName (Exists)" -ForegroundColor Yellow
    }
    else {
        Write-Host "Converting Pedal Noise: $($file.Name)..." -ForegroundColor Green
        
        # FFmpeg command
        ffmpeg -i "$($file.FullName)" -compression_level 5 -n "$targetPath" -hide_banner -loglevel error
    }
}

Write-Host "Pedal Noise Conversion Complete!" -ForegroundColor Cyan