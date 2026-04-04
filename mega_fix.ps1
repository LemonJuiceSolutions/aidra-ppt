$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Start: $($html.Length)"

# ==========================================
# 1. SLIDE 2 - Lower HQ box to bottom
# ==========================================
# Push entire right column content to bottom
$html = $html.Replace(
    '.s2-right{',
    '.s2-right{justify-content:flex-end;'
)
Write-Host "After S2 fix: $($html.Length)"

# ==========================================
# 2. SLIDE 3 - Enhance bottom problem boxes 
# (already restructured, just boost visual)
# ==========================================
# Make boxes taller and bolder
$html = $html.Replace(
    '.s3-pb{flex:1;display:flex;flex-direction:column;gap:8px;padding:14px;border-radius:14px;',
    '.s3-pb{flex:1;display:flex;flex-direction:column;gap:10px;padding:18px 16px;border-radius:14px;'
)
$html = $html.Replace(
    '.s3-pb-t{font-weight:700;font-size:var(--f-md);color:var(--cream)}',
    '.s3-pb-t{font-weight:700;font-size:var(--f-lg);color:var(--cream)}'
)
Write-Host "After S3 box fix: $($html.Length)"

# ==========================================
# 3. SLIDE 5 (Funzionalit├á) - Font +2 sizes
# ==========================================
$html = $html.Replace(
    '.s5-c{padding:15px;display:flex;flex-direction:column;gap:7px;position:relative;overflow:hidden}',
    '.s5-c{padding:18px;display:flex;flex-direction:column;gap:9px;position:relative;overflow:hidden}'
)
# Increase s5 title and card text
$html = $html.Replace(
    '.s5-hl{font-size:clamp(1.6rem,3vw,2.5rem)}',
    '.s5-hl{font-size:clamp(1.9rem,3.4vw,2.9rem)}'
)
# Find and update s5 card title size
$html = $html.Replace(
    '.s5-ct{font-size:var(--f-base);font-weight:700;',
    '.s5-ct{font-size:var(--f-md);font-weight:700;'
)
$html = $html.Replace(
    '.s5-cd{font-size:var(--f-xs);',
    '.s5-cd{font-size:var(--f-sm);'
)
Write-Host "After S5 font fix: $($html.Length)"

# ==========================================
# 4A. SLIDE 7 - Remove collab box, show Quid logo cleanly
# ==========================================
# Find and replace the collab glass box with a clean Quid header
$collabStart = $html.IndexOf('<div class="s7-collab glass stagger">')
$collabEnd = $html.IndexOf('</div>', $collabStart) + 6  # close the div

Write-Host "Collab start: $collabStart, end: $collabEnd"
Write-Host "Collab content: $($html.Substring($collabStart, $collabEnd - $collabStart).Substring(0, 100))..."

# Replace the collab div with just the Quid logo + badge
$oldCollab = $html.Substring($collabStart, $collabEnd - $collabStart)
$newCollab = '<div class="s7-quid-badge stagger">' +
    $html.Substring($html.IndexOf('<img class="s7-quid-img"'), $html.IndexOf('>', $html.IndexOf('<img class="s7-quid-img"')) - $html.IndexOf('<img class="s7-quid-img"') + 1) +
    '</div>'

Write-Host "New collab length: $($newCollab.Length)"
$html2 = $html.Replace($oldCollab, $newCollab)
if ($html2.Length -ne $html.Length) {
    Write-Host "Collab replaced OK"
    $html = $html2
} else {
    Write-Host "Collab NOT replaced"
}

Write-Host "After S7 collab fix: $($html.Length)"

# Add CSS for the new badge + s5 font additions
$cssInsert = @'
/* Quid badge - clean display */
.s7-quid-badge{display:flex;align-items:center;gap:16px;padding:10px 0 18px}
.s7-quid-badge img{height:52px;width:auto;max-width:220px;object-fit:contain;filter:brightness(1.2)}
/* S5 overrides for larger text */
.s5-ic{font-size:18px}
/* Wireframe canvas */
.wire-canvas{position:absolute;inset:0;width:100%;height:100%;z-index:0;pointer-events:none;opacity:0.6}
'@

$html = $html.Replace('/* Quid badge', '/* Quid badge') # idempotent check
# Insert before closing </style>
$styleClose = $html.LastIndexOf('</style>')
$html = $html.Substring(0, $styleClose) + $cssInsert + $html.Substring($styleClose)
Write-Host "After CSS add: $($html.Length)"

[System.IO.File]::WriteAllText($f, $html, [System.Text.Encoding]::UTF8)
Write-Host "SAVED - phase 1"
