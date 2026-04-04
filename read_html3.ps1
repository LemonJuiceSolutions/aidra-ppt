$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Show full s3-pbs section
$idx = $c.IndexOf('<div class="s3-pbs')
Write-Host "s3-pbs at: $idx"
Write-Host $c.Substring($idx, 700)

Write-Host "==="
# Show full s5 section - find all s5-ic
$start = $c.IndexOf('class="s5-ic"')
Write-Host "All s5 cards:"
$cur = $start
for ($j = 0; $j -lt 10; $j++) {
    if ($cur -lt 0) { break }
    $end = $c.IndexOf('</div>', $cur + 20)
    Write-Host "[$j] s5-ic at $cur -> title follows:"
    $titleStart = $c.IndexOf('s5-t">', $cur)
    $titleEnd = $c.IndexOf('</div>', $titleStart)
    if ($titleStart -gt 0) {
        Write-Host $c.Substring($titleStart, [Math]::Min($titleEnd - $titleStart + 6, 60))
    }
    $cur = $c.IndexOf('class="s5-ic"', $cur + 10)
}
