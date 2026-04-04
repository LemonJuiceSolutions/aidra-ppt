$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$lines = [System.IO.File]::ReadAllLines($f)
# Show S2 right column  
Write-Host "=== S2 RIGHT COLUMN ==="
for ($i=290; $i -le 330; $i++) { Write-Host "$($i): $($lines[$i])" }
# Show S5 CSS
$html = [System.IO.File]::ReadAllText($f)
$idx = $html.IndexOf('.s5{')
Write-Host "`n=== S5 CSS ==="
Write-Host $html.Substring($idx, 600)
# Show S7 collab section
$idx7 = $html.IndexOf('s7-collab')
Write-Host "`n=== S7 COLLAB CSS ==="
Write-Host $html.Substring($idx7, 300)
