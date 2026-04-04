$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

Write-Host "=== LOGO SIZES ==="
$idx = $c.IndexOf('s2-logo-tile img{')
Write-Host $c.Substring($idx, 80)
$idx2 = $c.IndexOf('min-height:')
Write-Host $c.Substring($idx2, 30)

Write-Host "=== S3-QUOTE (should be GONE) ==="
$idx3 = $c.IndexOf('s3-quote glass-strong')
Write-Host "Found at: $idx3 (should be -1)"

Write-Host "=== S3-PB-IC 1 ==="
$idx4 = $c.IndexOf('<div class="s3-pb-ic">')
Write-Host $c.Substring($idx4, 120)

Write-Host "=== S2-HQ-ICON ==="
$idx5 = $c.IndexOf('<div class="s2-hq-icon">')
Write-Host $c.Substring($idx5, 120)

Write-Host "=== S5-IC 1 ==="
$idx6 = $c.IndexOf('<div class="s5-ic">')
Write-Host $c.Substring($idx6, 100)
