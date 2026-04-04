$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Check S2 right column CSS
$idx = $html.IndexOf('.s2-right{')
Write-Host "=== S2-RIGHT CSS ==="
Write-Host $html.Substring($idx, 120)

# Check S3 structure
$idx3 = $html.IndexOf('<div class="s3">')
Write-Host "`n=== S3 HTML (first 800 chars, data-uris redacted) ==="
$s3 = $html.Substring($idx3, 800)
$s3clean = [regex]::Replace($s3, 'data:[^"]+', '[DATA]')
Write-Host $s3clean

# Check S5 font CSS
$idx5 = $html.IndexOf('.s5-ct{')
Write-Host "`n=== S5 TEXT CSS ==="
Write-Host $html.Substring($idx5, 150)

# Check S7 badge area
$idx7 = $html.IndexOf('s7-quid-badge stagger')
Write-Host "`n=== S7 BADGE present: $($idx7 -ge 0) ==="

# Check wire canvas
$wireCount = ([regex]::Matches($html, 'wire-canvas')).Count
Write-Host "Wire canvas refs: $wireCount"

Write-Host "`nFile size: $($html.Length)"
