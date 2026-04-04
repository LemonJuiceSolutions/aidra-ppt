$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $($c.Length) chars"

# =============================================
# 1. FRIDAI WATERMARK - move to RIGHT side
# =============================================
$wIdx = $c.IndexOf('.slide-white::after{content:')
if ($wIdx -ge 0) {
    $wEnd = $c.IndexOf('}', $wIdx) + 1
    $oldRule = $c.Substring($wIdx, $wEnd - $wIdx)

    # Extract the data URI
    $urlStart = $oldRule.IndexOf("url('") + 5
    $urlEnd   = $oldRule.IndexOf("')", $urlStart)
    $dataUri  = $oldRule.Substring($urlStart, $urlEnd - $urlStart)

    # New rule: right-aligned, vertically centered
    $newRule = ".slide-white::after{content:'';position:absolute;top:50%;right:-600px;transform:translateY(-50%);width:2600px;height:2600px;background:url('$dataUri') center/contain no-repeat;opacity:.07;pointer-events:none;z-index:0}"
    $c = $c.Substring(0, $wIdx) + $newRule + $c.Substring($wEnd)
    Write-Host "1. Watermark moved to right"
} else {
    Write-Host "ERROR: watermark CSS not found"
}

# =============================================
# 2. VIDEO - full centered, dominant on slide 1
# =============================================
# Replace old video CSS (whatever it currently is)
$oldVideoCss = '.cover-video{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:90%;height:90%;object-fit:contain;opacity:.82;z-index:1;pointer-events:none;border-radius:4px}'
$newVideoCss = '.cover-video{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:96%;height:96%;object-fit:contain;opacity:1;z-index:1;pointer-events:none}'
$c = $c.Replace($oldVideoCss, $newVideoCss)
Write-Host "2. Video CSS updated - full opacity, 96% size"

# Remove the overlay div (no longer needed - video is the main element)
$c = $c.Replace('<div class="cover-vid-overlay"></div>', '')
Write-Host "3. Overlay div removed"

# Remove overlay CSS too
$c = $c.Replace("`n/* Video overlay - dark gradient to keep title readable */`n.cover-vid-overlay{position:absolute;inset:0;background:linear-gradient(135deg,rgba(4,9,30,.72) 0%,rgba(4,9,30,.38) 50%,rgba(4,9,30,.68) 100%);z-index:1;pointer-events:none}", '')
Write-Host "4. Overlay CSS removed"

# Make s8 (slide 1 text content) a compact transparent overlay at top
# Bump z-index above video and make it a small header strip
$c = $c.Replace('.s8{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;gap:24px;width:100%;position:relative;z-index:2}',
                '.s8{display:flex;flex-direction:column;align-items:center;justify-content:flex-end;text-align:center;gap:12px;width:100%;height:100%;position:relative;z-index:3;padding-bottom:28px}')
Write-Host "5. s8 moved to bottom overlay, z-index:3"

# =============================================
# SAVE
# =============================================
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! Saved $($c.Length) chars"
