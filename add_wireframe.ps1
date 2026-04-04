$f = 'C:\Users\romina.masiero\Desktop\Lemonjuice\PPT\presentazione_aidra.html'
$html = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)
Write-Host "Start: $($html.Length)"

# ==========================================
# ADD WIREFRAME CANVAS JS
# ==========================================
$wireJS = @'
<script>
// ÔöÇÔöÇÔöÇ WIREFRAME BACKGROUND (AIDRA style) ÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇÔöÇ
function initWireBg(canvas) {
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  let W, H, nodes = [], raf;
  const COLORS = ['rgba(0,212,255,', 'rgba(123,47,190,', 'rgba(224,64,251,'];
  const SHAPES = [3, 4, 6, 8];  // triangle, square, hex, oct

  function setup() {
    W = canvas.width  = canvas.offsetWidth  || 1280;
    H = canvas.height = canvas.offsetHeight || 720;
    nodes = [];
    const N = 28;
    for (let i = 0; i < N; i++) {
      nodes.push({
        x: Math.random() * W,
        y: Math.random() * H,
        vx: (Math.random() - 0.5) * 0.25,
        vy: (Math.random() - 0.5) * 0.25,
        r: Math.random() * 22 + 8,
        sides: SHAPES[Math.floor(Math.random() * SHAPES.length)],
        angle: Math.random() * Math.PI * 2,
        spin: (Math.random() - 0.5) * 0.012,
        alpha: Math.random() * 0.06 + 0.03,
        col: COLORS[Math.floor(Math.random() * COLORS.length)]
      });
    }
  }

  function poly(cx, cy, r, sides, angle) {
    ctx.beginPath();
    for (let i = 0; i <= sides; i++) {
      const a = (i / sides) * Math.PI * 2 + angle;
      const fn = i === 0 ? 'moveTo' : 'lineTo';
      ctx[fn](cx + Math.cos(a) * r, cy + Math.sin(a) * r);
    }
    ctx.closePath();
  }

  function frame() {
    ctx.clearRect(0, 0, W, H);

    // Connections
    for (let i = 0; i < nodes.length; i++) {
      for (let j = i + 1; j < nodes.length; j++) {
        const dx = nodes[i].x - nodes[j].x, dy = nodes[i].y - nodes[j].y;
        const d = Math.sqrt(dx * dx + dy * dy);
        if (d < 200) {
          const a = (1 - d / 200) * 0.06;
          ctx.strokeStyle = `rgba(0,212,255,${a})`;
          ctx.lineWidth = 0.5;
          ctx.beginPath();
          ctx.moveTo(nodes[i].x, nodes[i].y);
          ctx.lineTo(nodes[j].x, nodes[j].y);
          ctx.stroke();
        }
      }
    }

    // Shapes
    nodes.forEach(n => {
      ctx.strokeStyle = n.col + n.alpha + ')';
      ctx.lineWidth = 0.7;
      poly(n.x, n.y, n.r, n.sides, n.angle);
      ctx.stroke();
      // Inner detail
      ctx.strokeStyle = n.col + (n.alpha * 0.4) + ')';
      poly(n.x, n.y, n.r * 0.5, n.sides, n.angle + Math.PI / n.sides);
      ctx.stroke();

      n.x += n.vx; n.y += n.vy; n.angle += n.spin;
      if (n.x < -n.r) n.x = W + n.r;
      if (n.x > W + n.r) n.x = -n.r;
      if (n.y < -n.r) n.y = H + n.r;
      if (n.y > H + n.r) n.y = -n.r;
    });

    raf = requestAnimationFrame(frame);
  }

  setup();
  frame();

  // Reinit on slide resize
  const ro = new ResizeObserver(() => { cancelAnimationFrame(raf); setup(); frame(); });
  ro.observe(canvas.parentElement);
}

// Init all wire canvases when deck is ready
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.wire-canvas').forEach(c => initWireBg(c));
});
</script>
'@

# Insert JS before </body>
$html = $html.Replace('</body>', $wireJS + '</body>')

# ==========================================
# ADD CANVAS ELEMENTS TO DARK SLIDES
# ==========================================
# Add to each slide-dark: a wire-canvas before existing content
# Find all slide-dark sections and add canvas

# For slides 1 (cover), 3 (contesto), 5 (funzionalita), 7 (caso studio) - dark slides
# They all have class "slide-dark"
# Add canvas after <div class="slide slide-dark" data-theme="dark">
$pattern = '<div class="slide slide-dark" data-theme="dark">'
$replacement = '<div class="slide slide-dark" data-theme="dark"><canvas class="wire-canvas"></canvas>'
$html = $html.Replace($pattern, $replacement)

# Also cover slide (slide-cover)  
$html = $html.Replace(
    '<div class="slide slide-cover" data-theme="dark">',
    '<div class="slide slide-cover" data-theme="dark"><canvas class="wire-canvas"></canvas>'
)

Write-Host "After wire canvas add: $($html.Length)"

# ==========================================
# S7 CLEAN: Verify structure and fix
# ==========================================
# Find the s7-d (description text) and make sure it comes after badge
$badgeEnd = $html.IndexOf('</div>', $html.IndexOf('s7-quid-badge')) + 6
Write-Host "After badge ends at: $badgeEnd"
Write-Host "Content: $($html.Substring($badgeEnd, 150))"

Write-Host "Final length: $($html.Length)"
[System.IO.File]::WriteAllText($f, $html, [System.Text.Encoding]::UTF8)
Write-Host "SAVED"
