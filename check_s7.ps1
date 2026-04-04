$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Find s7-quid-badge or s7-collab
$idx = $html.IndexOf('s7-quid-badge')
if ($idx -lt 0) { $idx = $html.IndexOf('s7-collab') }
Write-Host "S7 collab/badge area:"
# Find the HTML element (not CSS)
$htmlIdx = $html.IndexOf('<div class="s7-quid-badge')
if ($htmlIdx -lt 0) { $htmlIdx = $html.IndexOf('<div class="s7-collab') }
Write-Host "HTML at: $htmlIdx"
# Show content after (skip SVG)
$segment = $html.Substring($htmlIdx, 200)
# Just show first 200 chars  
Write-Host $segment.Substring(0, [Math]::Min(200, $segment.Length))

# Show the area after the quid badge to see if orphan divs exist
$afterBadge = $html.IndexOf('</div>', $htmlIdx + 100)
Write-Host "`nAfter badge first </div> at: $afterBadge"
Write-Host $html.Substring($afterBadge - 10, 100)
