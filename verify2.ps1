$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "File: $($c.Length)"

Write-Host "=== WATERMARK position ==="
$i = $c.IndexOf('.slide-white::after{')
$rule = $c.Substring($i, 200)
$uriStart = $rule.IndexOf("url('")
Write-Host $rule.Substring(0, $uriStart)

Write-Host "=== VIDEO CSS ==="
Write-Host $c.Substring($c.IndexOf('.cover-video{'), 160)

Write-Host "=== OVERLAY DIV present? ==="
Write-Host ("cover-vid-overlay found: " + ($c.IndexOf('cover-vid-overlay') -ge 0))

Write-Host "=== S8 CSS ==="
$s8i = $c.IndexOf('.s8{display:flex')
Write-Host $c.Substring($s8i, 160)

Write-Host "=== SLIDE 1 HTML (video tag) ==="
$vi = $c.IndexOf('<video class="cover-video"')
Write-Host $c.Substring($vi, 100)
