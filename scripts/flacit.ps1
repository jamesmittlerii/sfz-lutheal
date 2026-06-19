# Define paths - using quotes for the accented 'é'
$sourceDir = "E:\Users\chica\downloads\LuthCimbalom\Cimbalom (All Stops)\Release"
$destDir = "E:\Users\chica\downloads\dummy\Luthéal Piano - Release Cimbalom (All Stops) Samples"

# Create destination if it doesn't exist
if (!(Test-Path $destDir)) {
    New-Item -ItemType Directory -Force -Path $destDir
}

# Get all WAV files recursively, excluding "pedal noise"
$wavFiles = Get-ChildItem -Path $sourceDir -Filter *.wav -Recurse | Where-Object { 
    $_.FullName -notmatch "pedal noise" 
}

Write-Host "Found $($wavFiles.Count) WAV files. Starting check/conversion..." -ForegroundColor Cyan

foreach ($file in $wavFiles) {
    # Determine the target filename (changing extension to .flac)
    $targetName = $file.Name -replace '\.wav$', '.flac'
    $targetPath = Join-Path $destDir $targetName

    # Check if the file already exists in the destination
    if (Test-Path $targetPath) {
        Write-Host "Skipping: $targetName (Already exists)" -ForegroundColor Yellow
    }
    else {
        Write-Host "Converting: $($file.Name)..." -ForegroundColor Green
        
        # FFmpeg command: 
        # -i: Input
        # -compression_level 5: Standard FLAC compression
        # -n: Never overwrite (extra safety)
        # -hide_banner -loglevel error: Keep the console clean
        ffmpeg -i "$($file.FullName)" -compression_level 5 -n "$targetPath" -hide_banner -loglevel error
    }
}

Write-Host "Task Complete!" -ForegroundColor Cyan