$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Find badge HTML element
$badgeHtmlIdx = $html.IndexOf('<div class="s7-quid-badge')
$badgeClose = $html.IndexOf('</div>', $badgeHtmlIdx + 14000) + 6  # skip SVG content

Write-Host "Badge closes at: $badgeClose"
Write-Host "Content from badge end:"
Write-Host $html.Substring($badgeClose, 400)

# Find where s7-d starts
$s7dIdx = $html.IndexOf('<p class="s7-d stagger">')
Write-Host "`ns7-d at: $s7dIdx"

# Remove orphan content between badge close and s7-d
if ($s7dIdx -gt $badgeClose) {
    $orphan = $html.Substring($badgeClose, $s7dIdx - $badgeClose)
    Write-Host "`nOrphan to remove: [$orphan]"
    
    # Replace orphan with just a newline
    $html2 = $html.Replace($orphan, [char]10 + '      ')
    Write-Host "Old: $($html.Length), New: $($html2.Length)"
    [System.IO.File]::WriteAllText($f, $html2, [System.Text.Encoding]::UTF8)
    Write-Host "SAVED - orphan removed"
}
