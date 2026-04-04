$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

$s3start = $html.IndexOf('<div class="s3">')
$s4marker = $html.IndexOf('S4 COSA FACCIAMO', $s3start)
$s3blockEnd = $s4marker - 30
$s3block = $html.Substring($s3start, $s3blockEnd - $s3start)
# s3block ends with "\n  " (trailing spaces before s3-right closing </div>)

# OLD FULL to replace: s3block + s3-right close + s3 close
$oldFull = $s3block + '</div>' + [char]10 + '</div>'

# --- Extract parts ---
# Left inner: content of s3-left (excluding the s3-pbs)
$pbsComment = '    <!-- Problem boxes'
$pbsCommentIdx = $s3block.IndexOf($pbsComment)
$leftOpen = '<div class="s3-left">'
$leftOpenIdx = $s3block.IndexOf($leftOpen) + $leftOpen.Length
$leftInner = $s3block.Substring($leftOpenIdx, $pbsCommentIdx - $leftOpenIdx)
# leftInner: "\n    <span...descs\n    "

# pbs div content
$pbsDivTag = '<div class="s3-pbs stagger">'
$pbsDivStart = $s3block.IndexOf($pbsDivTag)
$pbsDivClose = $s3block.IndexOf('    </div>', $pbsDivStart) + 10
$pbsInner = $s3block.Substring($pbsDivStart + $pbsDivTag.Length, $pbsDivClose - $pbsDivStart - $pbsDivTag.Length)
# pbsInner: "\n      <div class=s3-pb>...</div>\n    "

# right inner
$rightTag = '<div class="s3-right">'
$rightStart = $s3block.IndexOf($rightTag) + $rightTag.Length
$rightInner = $s3block.Substring($rightStart).TrimEnd()
# rightInner: "\n    <div class=s3-stat>...</div>\n    <div class=s3-quote>...</div>"

# Build new S3 block
$nl = [char]10
$newS3 = '<div class="s3">' + $nl
$newS3 += '  <div class="s3-grid">' + $nl
$newS3 += '    <div class="s3-left">' + $leftInner + '</div>' + $nl
$newS3 += '    <div class="s3-right">' + $rightInner + $nl
$newS3 += '    </div>' + $nl
$newS3 += '  </div>' + $nl
$newS3 += '  <div class="s3-pbs stagger">' + $pbsInner + '</div>' + $nl

# NEW FULL = new S3 block + s3 closing </div>
$newFull = $newS3 + '</div>'

Write-Host "oldFull length: $($oldFull.Length)"
Write-Host "newFull length: $($newFull.Length)"
Write-Host "oldFull last 60: [$($oldFull.Substring($oldFull.Length - 60))]"
Write-Host "newFull last 60: [$($newFull.Substring($newFull.Length - 60))]"

$html2 = $html.Replace($oldFull, $newFull)
if ($html2.Length -ne $html.Length) {
    Write-Host "S3 RESTRUCTURE DONE! Old: $($html.Length) -> New: $($html2.Length)"
    [System.IO.File]::WriteAllText($f, $html2, [System.Text.Encoding]::UTF8)
    Write-Host "SAVED"
} else {
    Write-Host "FAILED - trying to debug..."
    # Check if oldFull exists
    $idx = $html.IndexOf($oldFull.Substring(0, 50))
    Write-Host "First 50 chars of oldFull found at: $idx"
    $idx2 = $html.IndexOf($oldFull.Substring($oldFull.Length - 50))
    Write-Host "Last 50 chars of oldFull found at: $idx2"
}
