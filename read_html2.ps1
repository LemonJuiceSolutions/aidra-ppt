$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Find full s3-quote div in HTML
$idx = $c.IndexOf('<div class="s3-quote')
Write-Host "s3-quote div at: $idx"
Write-Host $c.Substring($idx, 300)

Write-Host "==="
# Find s3-stat area full context
$idx2 = $c.IndexOf('<div class="s3-stat glass')
Write-Host "s3-stat div at: $idx2"
Write-Host $c.Substring($idx2, 300)

Write-Host "==="
# Find s3-pb-ic in HTML (actual content)
$idx3 = $c.IndexOf('class="s3-pb-ic"')
Write-Host "s3-pb-ic content at: $idx3"
Write-Host $c.Substring($idx3, 400)

Write-Host "==="
# Find s2-hq-icon in HTML
$idx4 = $c.IndexOf('class="s2-hq-icon"')
Write-Host "s2-hq-icon content at: $idx4"
Write-Host $c.Substring($idx4, 100)

Write-Host "==="
# Find s5-ic in HTML (actual content)
$idx5 = $c.IndexOf('class="s5-ic"')
Write-Host "s5-ic content at: $idx5"
Write-Host $c.Substring($idx5, 500)

Write-Host "==="
# .s2-logo-tile full CSS
$idx6 = $c.IndexOf('.s2-logo-tile{')
Write-Host ".s2-logo-tile full CSS:"
Write-Host $c.Substring($idx6, 200)

Write-Host "==="
# s2-logo-tile img full CSS
$idx7 = $c.IndexOf('.s2-logo-tile img{')
Write-Host ".s2-logo-tile img full CSS:"
Write-Host $c.Substring($idx7, 100)
