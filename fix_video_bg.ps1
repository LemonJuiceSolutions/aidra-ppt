$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $([Math]::Round($c.Length/1MB,1)) MB"

# Replace cover-video CSS: background, top-left, full slide
$oldCss = '.cover-video{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:400px;height:auto;object-fit:contain;opacity:1;z-index:2;border-radius:12px;box-shadow:0 8px 40px rgba(0,0,0,.5)}'
$newCss = '.cover-video{position:absolute;top:0;left:0;width:100%;height:100%;object-fit:cover;object-position:top left;opacity:.35;z-index:1;pointer-events:none}'

if ($c.IndexOf($oldCss) -ge 0) {
    $c = $c.Replace($oldCss, $newCss)
    Write-Host "CSS updated: background top-left"
} else {
    # Fallback: regex replace
    $c = [regex]::Replace($c, '\.cover-video\{[^}]+\}', $newCss)
    Write-Host "Regex replace done"
}

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! $([Math]::Round($c.Length/1MB,1)) MB"
