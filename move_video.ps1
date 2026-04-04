$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $([Math]::Round($c.Length/1MB,1)) MB"

# 1. Find and extract the full video tag
$vidStart = $c.IndexOf('<video class="cover-video"')
$vidEnd = $c.IndexOf('</video>', $vidStart) + 8
$videoTag = $c.Substring($vidStart, $vidEnd - $vidStart)
Write-Host "Video tag extracted: $($videoTag.Length) chars"

# 2. Remove video from its current position (S8 CONTATTI)
$c = $c.Substring(0, $vidStart) + $c.Substring($vidEnd)
Write-Host "Video removed from S8"

# 3. Find the first slide and insert video right after its opening tag
$slide1Start = $c.IndexOf('<div class="slide slide-white" data-theme="light">')
$insertPos = $slide1Start + '<div class="slide slide-white" data-theme="light">'.Length
$c = $c.Substring(0, $insertPos) + "`n" + $videoTag + "`n" + $c.Substring($insertPos)
Write-Host "Video inserted into Slide 1 (Chi siamo)"

# 4. Update CSS: 500px, centered, background, in blur
$newCss = '.cover-video{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:500px;height:auto;opacity:.45;z-index:0;pointer-events:none;filter:blur(4px);border-radius:16px}'
$c = [regex]::Replace($c, '\.cover-video\{[^}]+\}', $newCss)
Write-Host "CSS updated: 500px centered blurred background"

# 5. Save
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! $([Math]::Round($c.Length/1MB,1)) MB"

# Verify
$newVidPos = $c.IndexOf('<video class="cover-video"')
$newSlide1 = $c.IndexOf('<div class="slide slide-white"')
Write-Host "Video now at char: $newVidPos"
Write-Host "Slide 1 at char: $newSlide1"
Write-Host "Video is INSIDE slide 1: $($newVidPos -gt $newSlide1)"
