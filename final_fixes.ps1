$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Fix Quid img CSS - wider for SVG logo
$html = $html.Replace(
    '.s7-quid-img{height:36px;width:36px;object-fit:contain;border-radius:4px}',
    '.s7-quid-img{height:40px;width:auto;max-width:160px;object-fit:contain;filter:brightness(1.15)}'
)

# Fix S4 desc - confirm max-width:100%
$html = $html.Replace('max-width:900px}', 'max-width:100%}')

# Verify s3-grid and s3-pbs outside it
$s3gridIdx = $html.IndexOf('<div class="s3-grid">')
$s3pbsIdx = $html.IndexOf('<div class="s3-pbs stagger">')
Write-Host "s3-grid at: $s3gridIdx, s3-pbs at: $s3pbsIdx"
if ($s3pbsIdx -gt $s3gridIdx) { Write-Host "OK: s3-pbs is after s3-grid" }

Write-Host "HTML length: $($html.Length)"
[System.IO.File]::WriteAllText($f, $html, [System.Text.Encoding]::UTF8)
Write-Host "SAVED"
