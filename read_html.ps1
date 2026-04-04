$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

Write-Host "=== SLIDE 1 ==="
$idx3 = $c.IndexOf('class="slide slide-cover"')
Write-Host $c.Substring($idx3, 900)
