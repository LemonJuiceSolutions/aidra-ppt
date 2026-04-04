$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

$s3start = $html.IndexOf('<div class="s3">')
Write-Host "s3start: $s3start"

$s4marker = $html.IndexOf('S4 COSA FACCIAMO', $s3start)
Write-Host "s4marker: $s4marker"

$s3blockEnd = $s4marker - 30

# Show exact bytes around the end of S3 block
$segment = $html.Substring($s3blockEnd - 200, 250)
Write-Host "=== Content around s3blockEnd ==="
Write-Host $segment

# Show char codes
Write-Host "=== Char codes at s3blockEnd ==="
$near = $html.Substring($s3blockEnd, 40)
foreach ($ch in $near.ToCharArray()) {
    Write-Host -NoNewline "[$([int]$ch)]"
}
Write-Host ""
