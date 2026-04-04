$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Show the full S7 area from title to KPIs, skipping SVG content
$s7titleIdx = $html.IndexOf('<span class="lbl-dk stagger">Case study</span>')
$s7kpisIdx = $html.IndexOf('<div class="s7-kpis">')

# Build readable version by truncating large data URIs
$s7section = $html.Substring($s7titleIdx, $s7kpisIdx - $s7titleIdx)

# Replace SVG/PNG base64 data with placeholder
$s7clean = [regex]::Replace($s7section, 'data:(image|application)/[^"]+', '[...DATA_URI...]')

Write-Host "=== S7 TOP SECTION ==="
Write-Host $s7clean
