$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Start: $($html.Length)"

# ==========================================
# FIX 1: S2 - HQ box lower (fix CSS order)
# justify-content MUST come after display:flex
# ==========================================
$html = $html.Replace(
    '.s2-right{justify-content:flex-end;display:flex;flex-direction:column;gap:14px}',
    '.s2-right{display:flex;flex-direction:column;justify-content:flex-end;gap:20px}'
)
# Reduce gap between HQ and partners when together at bottom
$html = $html.Replace(
    'style="margin-top:auto"',
    'style="margin-top:16px"'
)
Write-Host "After S2: $($html.Length)"

# ==========================================
# FIX 2: S3 - ensure 3 boxes are full width below
# Already restructured - just make sure CSS is correct
# ==========================================
# Make sure s3 is flex column
$html = $html.Replace(
    '.s3{display:flex;flex-direction:column;gap:16px;',
    '.s3{display:flex;flex-direction:column;gap:20px;'
)
# Make boxes span full width with equal height
$html = $html.Replace(
    '.s3-pb{flex:1;display:flex;flex-direction:column;gap:10px;padding:18px 16px;border-radius:14px;',
    '.s3-pb{flex:1;display:flex;flex-direction:column;gap:10px;padding:20px 18px;border-radius:14px;min-height:120px;'
)
Write-Host "After S3: $($html.Length)"

# ==========================================
# FIX 3: S5 Funzionalita - font +2 sizes
# Card title is .s5-t, bullet is .s5-ul li
# ==========================================
$html = $html.Replace(
    '.s5-t{font-weight:700;font-size:var(--f-base)}',
    '.s5-t{font-weight:700;font-size:var(--f-md)}'
)
$html = $html.Replace(
    '.s5-ul li{font-size:var(--f-xs);',
    '.s5-ul li{font-size:var(--f-sm);'
)
# Also increase icon size
$html = $html.Replace(
    '.s5-ic{width:30px;height:30px;border-radius:8px;',
    '.s5-ic{width:34px;height:34px;border-radius:8px;'
)
Write-Host "After S5: $($html.Length)"

# ==========================================
# FIX 4: S7 - Quid badge styling
# ==========================================
# Make badge display better (larger logo, bolder)
$html = $html.Replace(
    '.s7-quid-badge{display:flex;align-items:center;gap:16px;padding:10px 0 18px}',
    '.s7-quid-badge{display:flex;align-items:center;gap:0;padding:0 0 20px}'
)
$html = $html.Replace(
    '.s7-quid-badge img{height:52px;width:auto;max-width:220px;object-fit:contain;filter:brightness(1.2)}',
    '.s7-quid-badge img{height:58px;width:auto;max-width:260px;object-fit:contain;filter:brightness(1.3) contrast(1.1)}'
)
Write-Host "After S7: $($html.Length)"

# ==========================================
# FIX 5: Wire canvas - ensure it's properly positioned
# ==========================================
$html = $html.Replace(
    '.wire-canvas{position:absolute;inset:0;width:100%;height:100%;z-index:0;pointer-events:none;opacity:0.6}',
    '.wire-canvas{position:absolute;inset:0;width:100%;height:100%;z-index:0;pointer-events:none;opacity:1}'
)
Write-Host "After wire: $($html.Length)"

[System.IO.File]::WriteAllText($f, $html, [System.Text.Encoding]::UTF8)
Write-Host "SAVED: $($html.Length)"
