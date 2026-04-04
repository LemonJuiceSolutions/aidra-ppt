$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

$s3start = $html.IndexOf('<div class="s3">')
$s4marker = $html.IndexOf('S4 COSA FACCIAMO', $s3start)
$s3blockEnd = $s4marker - 30
$s3block = $html.Substring($s3start, $s3blockEnd - $s3start)

# s3block ends with "  " (last 2 chars are spaces before s3-right </div>)
# At s3blockEnd: </div>\n</div>\n</div>...  (s3-right close, s3 close, slide close)

# OLD FULL = s3block + "</div>" (s3-right) + "\n</div>" (s3)
$oldFull = $s3block + '</div>' + [char]10 + '</div>'

# Extract left content (title + descs), between s3-left opening and s3-pbs comment
$leftOpen = '<div class="s3-left">'
$leftOpenIdx = $s3block.IndexOf($leftOpen) + $leftOpen.Length
$pbsComment = '    <!-- Problem boxes'
$pbsCommentIdx = $s3block.IndexOf($pbsComment)
$leftInner = $s3block.Substring($leftOpenIdx, $pbsCommentIdx - $leftOpenIdx)

# Extract s3-pbs div (problem boxes)
$pbsDivTag = '<div class="s3-pbs stagger">'
$pbsDivStart = $s3block.IndexOf($pbsDivTag)
# Find the matching </div> for s3-pbs
$pbsDivEnd = $s3block.IndexOf('    </div>', $pbsDivStart) + 14  # "    </div>\n"
$pbsDiv = $s3block.Substring($pbsDivStart, $pbsDivEnd - $pbsDivStart)

# Extract s3-right div (from its opening to end of s3block)
$rightTag = '<div class="s3-right">'
$rightStart = $s3block.IndexOf($rightTag)
$rightContent = $s3block.Substring($rightStart).TrimEnd()
# rightContent ends with  </div> (closing s3-right, but without the leading 2 spaces since those were the s3block trailer)
# Actually rightContent should end with \n  (the trailing \n+2spaces of s3block), let's check
Write-Host "rightContent last 20 chars: [$($rightContent)]"

