$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Show full S7 section - from s7-wrap to s7-kpis
$s7wrap = $html.IndexOf('<div class="s7-wrap">')
$s7kpis = $html.IndexOf('<div class="s7-kpis">', $s7wrap)

# Count chars between (should be top section)
$s7top = $html.Substring($s7wrap, $s7kpis - $s7wrap)
Write-Host "S7 wrap to kpis length: $($s7top.Length)"

# Show everything AFTER badge </div> up to s7-kpis, skipping SVG
$badgeHtmlIdx = $html.IndexOf('<div class="s7-quid-badge')
$badgeClose = $html.IndexOf('</div>', $badgeHtmlIdx + 14000) + 6
$sectionAfterBadge = $html.Substring($badgeClose, $s7kpis - $badgeClose)
Write-Host "`nContent after badge (before kpis):"
Write-Host $sectionAfterBadge
