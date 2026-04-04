$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $($c.Length) chars"

# =============================================
# 1. FRIDAI WATERMARK - 5x bigger, centered
# =============================================
# Old CSS (single line, find exactly)
$oldWatermark = '.slide-white::after{content:'''';position:absolute;right:-80px;bottom:-80px;width:520px;height:520px;background:url('''
$wIdx = $c.IndexOf('.slide-white::after{content:')
Write-Host "Watermark CSS at: $wIdx"
if ($wIdx -ge 0) {
    # Find end of this CSS rule
    $wEnd = $c.IndexOf('}', $wIdx) + 1
    $oldRule = $c.Substring($wIdx, $wEnd - $wIdx)
    Write-Host "Old rule length: $($oldRule.Length)"

    # Extract the data URI from the old rule (between url(' and ') center)
    $urlStart = $oldRule.IndexOf("url('") + 5
    $urlEnd = $oldRule.IndexOf("')", $urlStart)
    $dataUri = $oldRule.Substring($urlStart, $urlEnd - $urlStart)
    Write-Host "Data URI length: $($dataUri.Length)"

    # Build new rule: 5x bigger (520->2600), centered vertically and horizontally
    $newRule = ".slide-white::after{content:'';position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:2600px;height:2600px;background:url('$dataUri') center/contain no-repeat;opacity:.07;pointer-events:none;z-index:0}"

    $c = $c.Substring(0, $wIdx) + $newRule + $c.Substring($wEnd)
    Write-Host "1. Watermark updated to 5x, centered"
} else {
    Write-Host "ERROR: watermark CSS not found"
}

# =============================================
# 2. VIDEO - centered and large on slide 1
# =============================================
# Replace cover-video CSS
$oldVideoCss = '.cover-video{position:absolute;top:0;left:0;width:100%;height:100%;object-fit:cover;opacity:.18;z-index:0;pointer-events:none}'
$newVideoCss = '.cover-video{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:90%;height:90%;object-fit:contain;opacity:.82;z-index:1;pointer-events:none;border-radius:4px}'

$c = $c.Replace($oldVideoCss, $newVideoCss)
Write-Host "2. Video CSS updated"

# Make sure the title content (s8) has higher z-index than video
$c = $c.Replace('.s8{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;gap:24px;width:100%;position:relative;z-index:1}',
                '.s8{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;gap:24px;width:100%;position:relative;z-index:2}')
Write-Host "3. s8 z-index bumped to 2"

# Also add a dark overlay above the video but below the text, so text stays readable
# Insert an overlay div right after the video tag
$videoTag = '<video class="cover-video" src="Video.mp4" autoplay muted loop playsinline></video>'
$overlayDiv = '<div class="cover-vid-overlay"></div>'
if ($c.IndexOf($videoTag + $overlayDiv) -lt 0) {
    $c = $c.Replace($videoTag, $videoTag + $overlayDiv)
    Write-Host "4. Overlay div added"
}

# Add overlay CSS before </style>
$overlayCss = @"

/* Video overlay - dark gradient to keep title readable */
.cover-vid-overlay{position:absolute;inset:0;background:linear-gradient(135deg,rgba(4,9,30,.72) 0%,rgba(4,9,30,.38) 50%,rgba(4,9,30,.68) 100%);z-index:1;pointer-events:none}
"@
$styleClose = $c.LastIndexOf('</style>')
$c = $c.Substring(0, $styleClose) + $overlayCss + $c.Substring($styleClose)
Write-Host "5. Overlay CSS added"

# =============================================
# SAVE
# =============================================
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! Saved $($c.Length) chars"
