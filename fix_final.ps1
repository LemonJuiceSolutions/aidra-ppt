$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Loaded: $($c.Length) chars"

# =============================================
# 1. FIX QUID IMG CSS (clean up the filter)
# =============================================
$c = $c.Replace('.s7-quid-img{height:40px;width:auto;max-width:160px;object-fit:contain;filter:brightness(1.15)}',
                '.s7-quid-img{height:58px;width:auto;max-width:260px;object-fit:contain}')
Write-Host "1. Quid img CSS fixed"

# =============================================
# 2. EMBED FRIDAI.png AS BASE64 WATERMARK ON LIGHT SLIDES
# =============================================
$logoBytes = [System.IO.File]::ReadAllBytes('C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\FRIDAI.png')
$logoB64 = [System.Convert]::ToBase64String($logoBytes)
$logoDataUri = "data:image/png;base64,$logoB64"
Write-Host "2. FRIDAI.png encoded: $($logoB64.Length) chars"

# Add CSS for the logo watermark on white slides
$watermarkCss = @"

/* FRIDAI logo watermark on light slides */
.slide-white{overflow:hidden}
.slide-white::after{content:'';position:absolute;right:-80px;bottom:-80px;width:520px;height:520px;background:url('$logoDataUri') center/contain no-repeat;opacity:0.055;pointer-events:none;z-index:0}
"@

# Insert before closing </style>
$styleClose = $c.LastIndexOf('</style>')
$c = $c.Substring(0, $styleClose) + $watermarkCss + $c.Substring($styleClose)
Write-Host "2. Watermark CSS added"

# =============================================
# 3. SAVE
# =============================================
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE! Saved $($c.Length) chars"
