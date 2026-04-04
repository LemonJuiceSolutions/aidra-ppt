$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

$s3start = $html.IndexOf('<div class="s3">')
$s4marker = $html.IndexOf('S4 COSA FACCIAMO', $s3start)
$s3blockEnd = $s4marker - 30  # start of </div>\n</div>\n... (s3 + slide closing)

# s3block includes s3-right closing, ends right before s3 </div>
$s3block = $html.Substring($s3start, $s3blockEnd - $s3start)

Write-Host "s3block last 150 chars:"
Write-Host $s3block.Substring($s3block.Length - 150)
Write-Host "---"
Write-Host "At s3blockEnd (first 40 chars):"
Write-Host $html.Substring($s3blockEnd, 40)
Write-Host "---"

# OLD: s3block (already includes s3-right </div>) + </div> (s3 closer)
# We need to find if s3block ends with \n</div> (s3-right) or not
$lastDiv = $s3block.LastIndexOf('</div>')
Write-Host "Last </div> in s3block at relative pos: $lastDiv"
Write-Host "Content after last </div>: [$($s3block.Substring($lastDiv + 6))]"
