$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Show the first slide
$slide1 = $c.IndexOf('<div class="slide slide-white"')
Write-Host "=== FIRST SLIDE starts at: $slide1 ==="
Write-Host $c.Substring($slide1, 500)

# Where is the video currently?
$vidStart = $c.IndexOf('<video class="cover-video"')
$vidEnd = $c.IndexOf('</video>', $vidStart) + 8
Write-Host "=== VIDEO at char $vidStart - $vidEnd ==="
Write-Host "Video tag + base64: $($vidEnd - $vidStart) chars"

# What slide is it in?
$beforeVid = $c.LastIndexOf('<div class="slide ', $vidStart)
Write-Host "=== SLIDE containing video ==="
Write-Host $c.Substring($beforeVid, 80)
