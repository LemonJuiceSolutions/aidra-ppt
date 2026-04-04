$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $($c.Length) chars"

# =============================================
# 1. SLIDE 2 - Increase partner logo sizes
# =============================================
$c = $c.Replace('.s2-logo-tile img{max-height:28px;max-width:100%;object-fit:contain}',
                '.s2-logo-tile img{max-height:46px;max-width:100%;object-fit:contain}')

# Make tile taller to accommodate bigger logos
$c = $c.Replace('justify-content:center;min-height:48px;',
                'justify-content:center;min-height:68px;')

Write-Host "1. Logo sizes updated"

# =============================================
# 2. SLIDE 3 - Remove s3-quote div
# =============================================
$quoteStart = $c.IndexOf('<div class="s3-quote glass-strong stagger">')
if ($quoteStart -ge 0) {
    $quoteEnd = $c.IndexOf('</div>', $quoteStart) + 6
    $c = $c.Substring(0, $quoteStart) + $c.Substring($quoteEnd)
    Write-Host "2. s3-quote removed"
} else {
    Write-Host "2. s3-quote NOT FOUND"
}

# =============================================
# 3. UPDATE CSS for icon divs
# =============================================
# s3-pb-ic: change from emoji font-size to SVG container
$c = $c.Replace('.s3-pb-ic{font-size:18px;margin-bottom:2px}',
                '.s3-pb-ic{width:24px;height:24px;margin-bottom:6px;display:flex;align-items:center;justify-content:center}')

# s2-hq-icon: change from emoji font-size to SVG container
$c = $c.Replace('.s2-hq-icon{font-size:22px}',
                '.s2-hq-icon{width:28px;height:28px;display:flex;align-items:center;justify-content:center}')

Write-Host "3. Icon CSS updated"

# =============================================
# 4. REPLACE ICONS WITH SVG
# =============================================

# --- S3-PB-IC icons ---
# Icon 1: Sistemi frammentati -> lightning bolt (fragmented/disconnected systems)
$svgIc1 = '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polyline></svg>'

# Icon 2: Processi manuali -> settings/cog (manual processes)
$svgIc2 = '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.07 4.93l-1.41 1.41"></path><path d="M4.93 4.93l1.41 1.41"></path><path d="M4.93 19.07l1.41-1.41"></path><path d="M19.07 19.07l-1.41-1.41"></path><line x1="12" y1="2" x2="12" y2="4"></line><line x1="12" y1="20" x2="12" y2="22"></line><line x1="2" y1="12" x2="4" y2="12"></line><line x1="20" y1="12" x2="22" y2="12"></line></svg>'

# Icon 3: Rischio di errore -> alert triangle (risk/error)
$svgIc3 = '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>'

# Replace each s3-pb-ic in order
$ic1 = $c.IndexOf('<div class="s3-pb-ic">')
if ($ic1 -ge 0) {
    $ic1End = $c.IndexOf('</div>', $ic1) + 6
    $c = $c.Substring(0, $ic1) + '<div class="s3-pb-ic">' + $svgIc1 + '</div>' + $c.Substring($ic1End)
    Write-Host "4a. s3-pb-ic 1 replaced"
}

$ic2 = $c.IndexOf('<div class="s3-pb-ic">', $ic1 + 100)
if ($ic2 -ge 0) {
    $ic2End = $c.IndexOf('</div>', $ic2) + 6
    $c = $c.Substring(0, $ic2) + '<div class="s3-pb-ic">' + $svgIc2 + '</div>' + $c.Substring($ic2End)
    Write-Host "4b. s3-pb-ic 2 replaced"
}

$ic3 = $c.IndexOf('<div class="s3-pb-ic">', $ic2 + 100)
if ($ic3 -ge 0) {
    $ic3End = $c.IndexOf('</div>', $ic3) + 6
    $c = $c.Substring(0, $ic3) + '<div class="s3-pb-ic">' + $svgIc3 + '</div>' + $c.Substring($ic3End)
    Write-Host "4c. s3-pb-ic 3 replaced"
}

# --- S2-HQ-ICON ---
$svgPin = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#1B2A5C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>'

$hq = $c.IndexOf('<div class="s2-hq-icon">')
if ($hq -ge 0) {
    $hqEnd = $c.IndexOf('</div>', $hq) + 6
    $c = $c.Substring(0, $hq) + '<div class="s2-hq-icon">' + $svgPin + '</div>' + $c.Substring($hqEnd)
    Write-Host "4d. s2-hq-icon replaced"
}

# --- S5-IC icons (7 cards) ---
$svgS5 = @(
    # 1. Integrazione dati automatizzata - database/stack
    '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path></svg>',
    # 2. BI generativa (Agente AI) - bar chart rising
    '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line><line x1="2" y1="20" x2="22" y2="20"></line></svg>',
    # 3. Motore di regole AI-driven - cpu chip
    '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2" ry="2"></rect><rect x="9" y="9" width="6" height="6"></rect><line x1="9" y1="1" x2="9" y2="4"></line><line x1="15" y1="1" x2="15" y2="4"></line><line x1="9" y1="20" x2="9" y2="23"></line><line x1="15" y1="20" x2="15" y2="23"></line><line x1="20" y1="9" x2="23" y2="9"></line><line x1="20" y1="14" x2="23" y2="14"></line><line x1="1" y1="9" x2="4" y2="9"></line><line x1="1" y1="14" x2="4" y2="14"></line></svg>',
    # 4. Use case preconfigurati - checklist
    '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>',
    # 5. Dashboard e monitoraggio - monitor with graph
    '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>',
    # 6. Modularita e scalabilita - layers/stack
    '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 2 7 12 12 22 7 12 2"></polygon><polyline points="2 17 12 22 22 17"></polyline><polyline points="2 12 12 17 22 12"></polyline></svg>',
    # 7. Implementazione rapida - zap/speed
    '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#00D4FF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>'
)

$s5Cur = $c.IndexOf('<div class="s5-ic">')
for ($k = 0; $k -lt $svgS5.Length; $k++) {
    if ($s5Cur -lt 0) {
        Write-Host "4e. s5-ic $k NOT FOUND"
        break
    }
    $s5End = $c.IndexOf('</div>', $s5Cur) + 6
    $newDiv = '<div class="s5-ic">' + $svgS5[$k] + '</div>'
    $c = $c.Substring(0, $s5Cur) + $newDiv + $c.Substring($s5End)
    Write-Host "4e. s5-ic $($k+1) replaced"
    $s5Cur = $c.IndexOf('<div class="s5-ic">', $s5Cur + $newDiv.Length)
}

# =============================================
# 5. SAVE
# =============================================
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! Saved $($c.Length) chars"
