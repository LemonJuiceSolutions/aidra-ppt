$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Find all s5 related CSS
$pos = 0
while ($true) {
    $idx = $html.IndexOf('.s5-', $pos)
    if ($idx -lt 0) { break }
    Write-Host $html.Substring($idx, [Math]::Min(100, $html.Length - $idx))
    $pos = $idx + 4
    if ($pos -gt 30000) { break }  # CSS should be in first 30K chars
}
