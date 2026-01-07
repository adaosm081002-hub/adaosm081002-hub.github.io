Convert images to WebP/AVIF

Overview
- This folder contains a PowerShell script `convert-images.ps1` that converts JPG/JPEG/PNG files to WebP and AVIF using ImageMagick (`magick`).

Prerequisites
- ImageMagick installed with AVIF/WebP support and `magick` on PATH.
  - Windows builds: https://imagemagick.org
  - If ImageMagick lacks AVIF support, consider installing libheif-enabled build or use ffmpeg.

Quick usage
1. Dry run (shows which files will be converted):

```powershell
cd path\to\adaosm081002.github.io
scripts\convert-images.ps1 -DryRun
```

2. Convert images in-place (writes .webp and .avif next to originals):

```powershell
scripts\convert-images.ps1
```

3. Convert and put outputs in a separate folder `converted`, removing originals:

```powershell
scripts\convert-images.ps1 -OutputDir "converted" -RemoveOriginals
```

Notes and next steps
- After conversion, update your HTML to use the `<picture>` element so browsers that support AVIF/WebP will use them, with JPG/PNG as fallback. Example:

```html
<picture>
  <source type="image/avif" srcset="images/pic1.avif">
  <source type="image/webp" srcset="images/pic1.webp">
  <img src="images/pic1.jpg" alt="...">
</picture>
```

- You can also keep the original files and reference the new formats via `<picture>`.
- I can update your HTML (`index.html` and other pages) to use `<picture>` automatically if you want — say the word and I'll patch the files.
