$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Fix double-quote bug in Quid img tag: style="..."" alt="Quid"> ÔåÆ style="..." alt="Quid">
$html = $html.Replace('object-fit:contain"" alt="Quid">', 'object-fit:contain" alt="Progetto Quid">')

# Also fix the s5 CSS if not already done
$s5ctIdx = $html.IndexOf('.s5-ct{')
if ($s5ctIdx -ge 0) {
    Write-Host "s5-ct CSS: $($html.Substring($s5ctIdx, 80))"
}
$s5cdIdx = $html.IndexOf('.s5-cd{')
if ($s5cdIdx -ge 0) {
    Write-Host "s5-cd CSS: $($html.Substring($s5cdIdx, 80))"
}

# Make s2-right justify flex-end to lower HQ
$html = $html.Replace('.s2-right{display:flex;flex-direction:column;', '.s2-right{display:flex;flex-direction:column;justify-content:flex-end;')

Write-Host "Final length: $($html.Length)"
[System.IO.File]::WriteAllText($f, $html, [System.Text.Encoding]::UTF8)
Write-Host "SAVED"
