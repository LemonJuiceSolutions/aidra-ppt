$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $([Math]::Round($c.Length/1MB,1)) MB"

$newCss = '.cover-video{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:500px;height:auto;object-fit:contain;opacity:.6;z-index:1;pointer-events:none;filter:blur(6px)}'

$c = [regex]::Replace($c, '\.cover-video\{[^}]+\}', $newCss)
Write-Host "CSS: 500px centered background with blur"

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE"
