$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $([Math]::Round($c.Length/1MB,1)) MB"

# Replace cover-video CSS: 400px, top-left, blurred background
$newCss = '.cover-video{position:absolute;top:0;left:0;width:400px;height:auto;object-fit:cover;opacity:.55;z-index:1;pointer-events:none;filter:blur(8px);transform:scale(1.05)}'

$c = [regex]::Replace($c, '\.cover-video\{[^}]+\}', $newCss)
Write-Host "CSS updated: 400px, blur(8px), top-left, autoplay"

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! $([Math]::Round($c.Length/1MB,1)) MB"
