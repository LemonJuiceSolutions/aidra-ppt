$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Count wire canvases added
$wireCount = ([regex]::Matches($html, 'wire-canvas')).Count
Write-Host "Wire canvas occurrences: $wireCount"

# Find s7-quid-badge HTML (not CSS)
$pos = 0
$found = @()
while ($true) {
    $idx = $html.IndexOf('s7-quid-badge', $pos)
    if ($idx -lt 0) { break }
    $found += $idx
    $pos = $idx + 13
}
Write-Host "s7-quid-badge positions: $($found -join ', ')"

# Show the HTML badge (should be the last one)
$htmlBadge = $html.IndexOf('<div class="s7-quid-badge')
Write-Host "HTML badge at: $htmlBadge"
Write-Host $html.Substring($htmlBadge - 10, 80)

# Show what follows the badge's </div>
$badgeEndTag = $html.IndexOf('</div>', $htmlBadge + 14000) + 6  # skip the SVG content
Write-Host "`nAfter badge (at $($badgeEndTag)):"
Write-Host $html.Substring($badgeEndTag, 200)
