$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Show full S7 HTML
$s7start = $html.IndexOf('<div class="s7-wrap">')
Write-Host "=== S7 HTML ==="
Write-Host $html.Substring($s7start, 2500)
