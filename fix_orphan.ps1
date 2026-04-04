$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Find and remove the orphan LJ logo div that remained after partial replacement
# It starts right after the badge's </div>
$badgeIdx = $html.IndexOf('<div class="s7-quid-badge')
$badgeClose = $html.IndexOf('</div>', $badgeIdx + 100) + 6  # end of badge </div>

# Show what comes after the badge
$afterBadge = $html.Substring($badgeClose, 100)
Write-Host "After badge:"
Write-Host $afterBadge

# Find the orphan LJ logo section (lj-logo or lj-icon after badge)
$ljLogoIdx = $html.IndexOf('<div class="lj-logo"', $badgeClose)
Write-Host "LJ logo orphan at: $ljLogoIdx"

if ($ljLogoIdx -gt 0 -and $ljLogoIdx -lt $badgeClose + 500) {
    # Find the end of this orphan section
    # Structure: <div class="lj-logo"> ... </div>  </div> (closes original collab)
    # Need to find matching close for lj-logo + one more </div> for original collab
    $afterLjLogo = $html.IndexOf('</div>', $ljLogoIdx) + 6  # closes lj-logo
    $afterCollab = $html.IndexOf('</div>', $afterLjLogo) + 6  # closes original s7-collab
    
    $orphanContent = $html.Substring($badgeClose, $afterCollab - $badgeClose)
    Write-Host "Orphan to remove: [$orphanContent]"
    
    $html2 = $html.Replace($orphanContent, "")
    Write-Host "Old length: $($html.Length), New: $($html2.Length)"
    [System.IO.File]::WriteAllText($f, $html2, [System.Text.Encoding]::UTF8)
    Write-Host "SAVED - orphan removed"
} else {
    Write-Host "No orphan found or it's far away - checking context..."
    Write-Host $html.Substring($badgeClose, 200)
}
