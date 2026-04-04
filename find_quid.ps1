$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f)
$pos = 0
while ($true) {
    $idx = $c.IndexOf('s7-quid-img', $pos)
    if ($idx -lt 0) { break }
    $len = [Math]::Min(80, $c.Length - $idx)
    Write-Host "Found at $($idx): $($c.Substring($idx, $len))"
    $pos = $idx + 11
}
