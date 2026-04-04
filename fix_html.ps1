$ppt = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT'
$f   = "$ppt\presentazione_aidra.html"
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
$quidSvgUri = [System.IO.File]::ReadAllText("$ppt\quid_svg_uri.txt").Trim()

Write-Host "HTML length: $($html.Length)"

# =============================================
# 1. FONT SIZES +2px (if not already done)
# =============================================
$html = $html.Replace('--f-xs:12px; --f-sm:13px; --f-base:14px; --f-md:16px;', '--f-xs:14px; --f-sm:15px; --f-base:16px; --f-md:18px;')
$html = $html.Replace('--f-lg:18px; --f-xl:20px; --f-2xl:24px;', '--f-lg:20px; --f-xl:22px; --f-2xl:26px;')

# =============================================
# 2. SLIDE 2 - align-items stretch
# =============================================
$html = $html.Replace('align-items:start;position:relative;z-index:1}.s2-left', 'align-items:stretch;position:relative;z-index:1}.s2-left')

# =============================================
# 3. SLIDE 3 CSS changes
# =============================================
# S3 grid ÔåÆ flex col
$html = $html.Replace('.s3{display:grid;grid-template-columns:1.15fr .85fr;gap:48px;width:100%;max-width:1220px;align-items:start;position:relative;z-index:1}', '.s3{display:flex;flex-direction:column;gap:16px;width:100%;max-width:1220px;position:relative;z-index:1}.s3-grid{display:grid;grid-template-columns:1.15fr .85fr;gap:48px;align-items:start}')
# Remove padding-top from s3-right
$html = $html.Replace('.s3-right{display:flex;flex-direction:column;gap:14px;padding-top:60px}', '.s3-right{display:flex;flex-direction:column;gap:14px}')
# Lighter problem box bg
$html = $html.Replace('background:rgba(0,212,255,.07);border:1px solid rgba(0,212,255,.22);', 'background:rgba(0,212,255,.2);border:1px solid rgba(0,212,255,.5);')
# pbs full width no top margin
$html = $html.Replace('.s3-pbs{display:flex;gap:10px;margin-top:4px}', '.s3-pbs{display:flex;gap:12px;margin-top:0;width:100%}')

# =============================================
# 4. SLIDE 4 - desc full width
# =============================================
$html = $html.Replace('color:rgba(10,10,20,.58);max-width:900px}', 'color:rgba(10,10,20,.58);max-width:100%}')

# =============================================
# 5. SLIDE 7 - KPI lighter bg, right lower
# =============================================
$html = $html.Replace('.s7-right{display:flex;flex-direction:column;gap:0}', '.s7-right{display:flex;flex-direction:column;gap:0;align-self:end}')
$html = $html.Replace('.s7-kpi{padding:18px 14px;text-align:center;display:flex;flex-direction:column;align-items:center;gap:4px}', '.s7-kpi{padding:18px 14px;text-align:center;display:flex;flex-direction:column;align-items:center;gap:4px;background:rgba(255,255,255,.18)!important;border:1px solid rgba(255,255,255,.3)!important;border-radius:16px}')

# =============================================
# S3 HTML RESTRUCTURE
# =============================================
$s3start = $html.IndexOf('<div class="s3">')
$s4marker = $html.IndexOf('S4 COSA FACCIAMO', $s3start)
$s3blockEnd = $s4marker - 30
$s3block = $html.Substring($s3start, $s3blockEnd - $s3start)

# Extract left content (title + descs, before the pbs comment)
$pbsCommentIdx = $s3block.IndexOf('    <!-- Problem boxes')
$leftInner = $s3block.Substring(17, $pbsCommentIdx - 17)  # skip '<div class="s3">\n  '

# Extract the s3-pbs div (problem boxes)
$pbsDivStart = $s3block.IndexOf('    <div class="s3-pbs stagger">')
# Find the closing </div> of s3-pbs (it's the line with 4 spaces + </div>)
$pbsDivClose = $s3block.IndexOf('    </div>', $pbsDivStart) + 14  # include closing tag + newline
$pbsDiv = $s3block.Substring($pbsDivStart, $pbsDivClose - $pbsDivStart)

# Extract s3-right div
$rightStart = $s3block.IndexOf('  <div class="s3-right">')
$rightDiv = $s3block.Substring($rightStart)

# Build new s3 block  
$newS3 = '<div class="s3">' + [char]10
$newS3 += '  <div class="s3-grid">' + [char]10
$newS3 += '  ' + $leftInner
$newS3 += '  ' + $rightDiv + [char]10
$newS3 += '  </div>' + [char]10
# Add pbs below (strip leading spaces - already has 4 spaces)
$newS3 += '  ' + $pbsDiv

Write-Host "Old S3 block length: $($s3block.Length)"
Write-Host "New S3 block length: $($newS3.Length)"

# Now we replace: old block + closing divs (s3-right + s3) with new block + closing divs (s3-grid + s3)
# At s3blockEnd: </div>\n</div>\n</div>\n  (1=s3-right, 2=s3, 3=slide)
# Old: s3block + \n  </div>\n</div>    (s3-right + s3 closing)  
# New: newS3 + </div>                  (just s3 closing since s3-right is inside s3-grid)

# Find exact old content to replace (including trailing </div> for s3-right and s3)
$oldFull = $s3block + [char]10 + '  </div>' + [char]10 + '</div>'
$newFull = $newS3 + '</div>'

$html2 = $html.Replace($oldFull, $newFull)
if ($html2.Length -ne $html.Length) {
    Write-Host "S3 restructure DONE"
    $html = $html2
} else {
    Write-Host "S3 restructure FAILED - length unchanged"
    # Debug: show what we're trying to match at the end
    Write-Host "Trying to match (last 100 chars of oldFull):"
    Write-Host $oldFull.Substring($oldFull.Length - 100)
}

# =============================================
# S7 QUID LOGO - Replace PNG with SVG
# =============================================
$quidImgStart = $html.IndexOf('<img class="s7-quid-img" src="data:image/png;base64,')
if ($quidImgStart -ge 0) {
    $quidImgEnd = $html.IndexOf('"', $quidImgStart + 52) # find closing " of src attr
    $oldQuidSrc = $html.Substring($quidImgStart, $quidImgEnd - $quidImgStart)
    $newQuidImg = '<img class="s7-quid-img" src="' + $quidSvgUri + '" style="height:44px;width:auto;object-fit:contain"'
    $html = $html.Replace($oldQuidSrc, $newQuidImg)
    Write-Host "Quid logo replaced with SVG"
} else {
    Write-Host "Quid PNG img not found"
}

Write-Host "Final HTML length: $($html.Length)"
[System.IO.File]::WriteAllText($f, $html, [System.Text.Encoding]::UTF8)
Write-Host "SAVED"
