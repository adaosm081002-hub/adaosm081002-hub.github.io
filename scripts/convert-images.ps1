<#
Convert images in the repository to WebP and AVIF using ImageMagick (magick)
Usage examples:
  # Dry run (shows what would be done)
  .\convert-images.ps1 -DryRun

  # Convert with defaults and write outputs next to originals
  .\convert-images.ps1

  # Convert, place outputs in ./converted, remove originals
  .\convert-images.ps1 -OutputDir "converted" -RemoveOriginals

Requirements:
  - ImageMagick with AVIF/WebP support installed and `magick` available in PATH.
  - On Windows, install from https://imagemagick.org or use WSL with libheif support.

This script converts *.jpg, *.jpeg, *.png (recursively) to .webp and .avif.
#>

param(
    [string]$RootPath = ".",
    [int]$QualityWebP = 80,
    [int]$QualityAvif = 60,
    [string]$OutputDir = "",
    [switch]$RemoveOriginals = $false,
    [switch]$DryRun = $false
)

function Convert-File($file) {
    $relPath = Resolve-Path -Path $file.FullName | ForEach-Object { $_.Path }
    $dir = Split-Path -Path $relPath -Parent
    if ($OutputDir -ne "") {
        $targetDir = Join-Path -Path $RootPath -ChildPath $OutputDir
        $sub = $dir.Substring((Resolve-Path -Path $RootPath).Path.Length).TrimStart('\')
        if ($sub -ne '') { $targetDir = Join-Path -Path $targetDir -ChildPath $sub }
        if (-not (Test-Path -Path $targetDir)) { if (-not $DryRun) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null } }
    } else {
        $targetDir = $dir
    }

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($relPath)
    $webpPath = Join-Path -Path $targetDir -ChildPath ($baseName + ".webp")
    $avifPath = Join-Path -Path $targetDir -ChildPath ($baseName + ".avif")

    $webpCmd = "magick `"$relPath`" -quality $QualityWebP `"$webpPath`""
    $avifCmd = "magick `"$relPath`" -quality $QualityAvif `"$avifPath`""

    Write-Host "Converting:`n  $relPath`n -> $webpPath`n -> $avifPath"
    if ($DryRun) { return }

    & magick $relPath -quality $QualityWebP $webpPath
    if ($LASTEXITCODE -ne 0) { Write-Warning "WebP conversion failed for $relPath" }

    & magick $relPath -quality $QualityAvif $avifPath
    if ($LASTEXITCODE -ne 0) { Write-Warning "AVIF conversion failed for $relPath" }

    if ($RemoveOriginals) {
        try { Remove-Item -LiteralPath $relPath -Force -ErrorAction Stop; Write-Host "Removed original: $relPath" } catch { Write-Warning ("Could not remove {0}: {1}" -f $relPath, $_) }
    }
}

# Validate magick presence
if (-not (Get-Command magick -ErrorAction SilentlyContinue)) {
    Write-Error "ImageMagick 'magick' not found in PATH. Install ImageMagick with WebP/AVIF support and ensure 'magick' is available."; exit 1
}

$resolvedRoot = Resolve-Path -Path $RootPath
Write-Host "Root: $($resolvedRoot.Path)"

$files = Get-ChildItem -Path $resolvedRoot -Include *.jpg, *.jpeg, *.png -Recurse -File
if ($files.Count -eq 0) { Write-Host "No JPG/PNG files found under $($resolvedRoot.Path)"; exit 0 }

foreach ($f in $files) { Convert-File $f }

Write-Host "Done. Converted $($files.Count) files."