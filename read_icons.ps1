$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# S2 logo tile CSS
$idx = $html.IndexOf('.s2-logo-tile')
Write-Host "=== S2 LOGO TILE CSS ==="
Write-Host $html.Substring($idx, 300)

# S3 right column HTML  
$idx3r = $html.IndexOf('<div class="s3-right">')
Write-Host "`n=== S3 RIGHT HTML ==="
Write-Host $html.Substring($idx3r, 500)

# Find all icon usages (emoji, s5-ic, etc)
Write-Host "`n=== ICON USAGES ==="
$lines = [System.IO.File]::ReadAllLines($f)
for ($i=0; $i -lt $lines.Count; $i++) {
    $l = $lines[$i]
    if ($l -match 's\d+-pb-ic|s5-ic|s4-num|hq-icon|lbl.*stagger|ic.*font' -and $l -notmatch 'display|width|height|border|background|font-size') {
        if ($l.Length -lt 200) { Write-Host "$i: $l" }
    }
}
