$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $($c.Length) chars"

# =============================================
# 1. S3 STAT BOX - push 67% box to bottom (align with pb boxes)
# =============================================
$c = $c.Replace('.s3-right{display:flex;flex-direction:column;gap:14px}',
                '.s3-right{display:flex;flex-direction:column;gap:14px;justify-content:flex-end}')
Write-Host "1. S3-right justify-content:flex-end done"

# =============================================
# 2. S6 VANTAGGI - Update s6-ic CSS for SVG
# =============================================
$c = $c.Replace('.s6-ic{font-size:22px}',
                '.s6-ic{width:40px;height:40px;border-radius:10px;background:linear-gradient(135deg,rgba(0,212,255,.12),rgba(100,80,255,.08));display:flex;align-items:center;justify-content:center;margin-bottom:6px;flex-shrink:0}')
Write-Host "2. s6-ic CSS updated"

# =============================================
# 3. S6 VANTAGGI - Replace emoji icons with SVG
# =============================================
$svgS6 = @(
    # 1. Insight in pochi giorni - clock/fast insight
    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>',
    # 2. Agente AI addestrato - brain/neural
    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9.5 2A2.5 2.5 0 0 1 12 4.5v15a2.5 2.5 0 0 1-4.96-.44 2.5 2.5 0 0 1-2.96-3.08 3 3 0 0 1-.34-5.58 2.5 2.5 0 0 1 1.32-4.24 2.5 2.5 0 0 1 1.98-3A2.5 2.5 0 0 1 9.5 2Z"></path><path d="M14.5 2A2.5 2.5 0 0 0 12 4.5v15a2.5 2.5 0 0 0 4.96-.44 2.5 2.5 0 0 0 2.96-3.08 3 3 0 0 0 .34-5.58 2.5 2.5 0 0 0-1.32-4.24 2.5 2.5 0 0 0-1.98-3A2.5 2.5 0 0 0 14.5 2Z"></path></svg>',
    # 3. Simulazioni what-if - git branch / fork
    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="6" y1="3" x2="6" y2="15"></line><circle cx="18" cy="6" r="3"></circle><circle cx="6" cy="18" r="3"></circle><path d="M18 9a9 9 0 0 1-9 9"></path></svg>',
    # 4. Architettura modulare - layout grid
    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>',
    # 5. Integrazione nativa - plug/connect
    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22V12m0 0 4-4m-4 4-4-4"></path><path d="M20 4H4v4l8 4 8-4V4z"></path></svg>',
    # 6. Continuous planning - refresh/cycle
    '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>'
)

$s6Cur = $c.IndexOf('<div class="s6-ic">')
for ($k = 0; $k -lt $svgS6.Length; $k++) {
    if ($s6Cur -lt 0) { Write-Host "s6-ic $k NOT FOUND"; break }
    $s6End = $c.IndexOf('</div>', $s6Cur) + 6
    $newDiv = '<div class="s6-ic">' + $svgS6[$k] + '</div>'
    $c = $c.Substring(0, $s6Cur) + $newDiv + $c.Substring($s6End)
    Write-Host "3. s6-ic $($k+1) replaced"
    $s6Cur = $c.IndexOf('<div class="s6-ic">', $s6Cur + $newDiv.Length)
}

# =============================================
# 4. VIDEO IN SLIDE 1 - add as background video
# =============================================
# Add CSS for cover video
$videoCss = @"
/* Cover video background */
.cover-video{position:absolute;top:0;left:0;width:100%;height:100%;object-fit:cover;opacity:.18;z-index:0;pointer-events:none}
"@

# Insert CSS before closing </style>
$c = $c.Replace('/* Cover video background */', '')  # remove if already there
$styleClose = $c.LastIndexOf('</style>')
$c = $c.Substring(0, $styleClose) + $videoCss + $c.Substring($styleClose)

# Add video element as first child of slide-cover (after the opening div tag)
$coverDiv = 'class="slide slide-cover" data-theme="cover">'
$coverIdx = $c.IndexOf($coverDiv)
$insertPos = $coverIdx + $coverDiv.Length
$videoTag = "`n<video class=`"cover-video`" src=`"Video.mp4`" autoplay muted loop playsinline></video>"
$c = $c.Substring(0, $insertPos) + $videoTag + $c.Substring($insertPos)
Write-Host "4. Video added to Slide 1"

# =============================================
# 5. SAVE
# =============================================
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! Saved $($c.Length) chars"
