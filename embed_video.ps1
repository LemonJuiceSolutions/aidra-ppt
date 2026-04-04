$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "HTML loaded: $($c.Length) chars"

# Read and encode video
$videoPath = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\Video.mp4'
$videoBytes = [System.IO.File]::ReadAllBytes($videoPath)
$videoB64 = [System.Convert]::ToBase64String($videoBytes)
$videoSrc = "data:video/mp4;base64,$videoB64"
Write-Host "Video encoded: $($videoB64.Length) chars"

# Replace src="Video.mp4" with base64 data URI
$c = $c.Replace('src="Video.mp4"', "src=`"$videoSrc`"")
Write-Host "Video embedded"

# Fix CSS: make sure cover-video is truly on top with correct positioning
# Also check/fix the z-index of cover-noise and cover-orbs (they should be below video)
$oldCss = '.cover-video{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:96%;height:96%;object-fit:contain;opacity:1;z-index:1;pointer-events:none}'
$newCss = '.cover-video{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:100%;height:100%;object-fit:contain;opacity:1;z-index:2;pointer-events:none}'
$c = $c.Replace($oldCss, $newCss)

# Push cover-noise and cover-orbs below video
$c = $c.Replace('.cover-noise{', '.cover-noise{z-index:0;')
$c = $c.Replace('.cover-orbs{', '.cover-orbs{z-index:0;')

# Keep s8 content above video
$c = $c.Replace('z-index:3;padding-bottom:28px}', 'z-index:4;padding-bottom:28px}')

Write-Host "CSS z-indexes fixed"

# Save
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! Saved $($c.Length) chars (~$([Math]::Round($c.Length/1MB,1)) MB)"
