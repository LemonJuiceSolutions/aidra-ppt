$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# S5 CSS
$idx5 = $html.IndexOf('.s5{')
Write-Host "=== S5 CSS ==="
Write-Host $html.Substring($idx5, 800)

# S7 HTML collab section
$s7collabIdx = $html.IndexOf('<div class="s7-collab')
Write-Host "`n=== S7 COLLAB HTML ==="
Write-Host $html.Substring($s7collabIdx, 600)
