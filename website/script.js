(() => {
  const qs = (s, r = document) => r.querySelector(s);
  const qsa = (s, r = document) => Array.from(r.querySelectorAll(s));

  // Mobile navigation
  const toggle = qs('.nav-toggle');
  const nav = qs('#site-nav, #nav');
  if (toggle && nav) {
    toggle.addEventListener('click', () => {
      const open = nav.classList.toggle('open');
      toggle.setAttribute('aria-expanded', String(open));
      toggle.classList.toggle('active', open);
    });
    qsa('a', nav).forEach(a => a.addEventListener('click', () => {
      nav.classList.remove('open');
      toggle.setAttribute('aria-expanded', 'false');
      toggle.classList.toggle('active', false);
    }));
    document.addEventListener('click', (e) => {
      if (!nav.classList.contains('open')) return;
      if (nav.contains(e.target) || toggle.contains(e.target)) return;
      nav.classList.remove('open');
      toggle.setAttribute('aria-expanded', 'false');
      toggle.classList.toggle('active', false);
    });
  }

  // Legacy menu button support
  const legacyMenu = qs('.menu-toggle');
  const legacyNav = qs('#nav');
  if (legacyMenu && legacyNav && !toggle) {
    legacyMenu.addEventListener('click', () => {
      const open = legacyNav.classList.toggle('open');
      legacyMenu.setAttribute('aria-expanded', String(open));
    });
  }

  // Year
  qsa('#year,[data-year]').forEach(el => { el.textContent = String(new Date().getFullYear()); });

  const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // Scroll reveal
  const revealEls = qsa('.reveal, [data-reveal]');
  if (revealEls.length) {
    if (reduce || !('IntersectionObserver' in window)) {
      revealEls.forEach(el => el.classList.add('is-visible'));
    } else {
      const io = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            io.unobserve(entry.target);
          }
        });
      }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
      revealEls.forEach(el => io.observe(el));
    }
  }

  // Subtle tilt for cards/panels
  if (!reduce && window.matchMedia('(pointer:fine)').matches) {
    qsa('[data-tilt]').forEach(card => {
      let raf = 0;
      const onMove = (e) => {
        const r = card.getBoundingClientRect();
        const x = (e.clientX - r.left) / r.width - 0.5;
        const y = (e.clientY - r.top) / r.height - 0.5;
        cancelAnimationFrame(raf);
        raf = requestAnimationFrame(() => {
          card.style.transform = `perspective(900px) rotateX(${(-y * 4).toFixed(2)}deg) rotateY(${(x * 5).toFixed(2)}deg) translateY(-2px)`;
        });
      };
      const reset = () => { cancelAnimationFrame(raf); card.style.transform = ''; };
      card.addEventListener('mousemove', onMove);
      card.addEventListener('mouseleave', reset);
      card.addEventListener('blur', reset, true);
    });
  }

  // Animated counters
  const counters = qsa('[data-count]');
  if (counters.length) {
    const animate = (el) => {
      const target = Number(el.getAttribute('data-count') || '0');
      const suffix = el.getAttribute('data-suffix') || '';
      if (reduce) { el.textContent = target + suffix; return; }
      const start = performance.now();
      const dur = 1200;
      const step = (now) => {
        const p = Math.min(1, (now - start) / dur);
        const eased = 1 - Math.pow(1 - p, 3);
        el.textContent = Math.round(target * eased) + suffix;
        if (p < 1) requestAnimationFrame(step);
      };
      requestAnimationFrame(step);
    };
    if (!('IntersectionObserver' in window)) counters.forEach(animate);
    else {
      const cio = new IntersectionObserver((entries) => {
        entries.forEach(entry => { if (entry.isIntersecting) { animate(entry.target); cio.unobserve(entry.target); } });
      }, { threshold: 0.5 });
      counters.forEach(el => cio.observe(el));
    }
  }

  // Canvas particle field (supports #fx-canvas or #starfield)
  const canvas = qs('#fx-canvas') || qs('#starfield');
  if (!canvas || reduce) return;
  const ctx = canvas.getContext('2d');
  if (!ctx) return;

  let w = 0, h = 0, dpr = 1, points = [], raf = 0;
  const rand = (a, b) => a + Math.random() * (b - a);

  function resize() {
    dpr = Math.min(window.devicePixelRatio || 1, 2);
    const rect = canvas.getBoundingClientRect();
    w = Math.max(1, Math.floor(rect.width));
    h = Math.max(1, Math.floor(rect.height));
    canvas.width = Math.floor(w * dpr);
    canvas.height = Math.floor(h * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    const count = Math.max(28, Math.min(90, Math.floor((w * h) / 24000)));
    points = Array.from({ length: count }, () => ({
      x: rand(0, w), y: rand(0, h), r: rand(0.4, 1.8),
      vx: rand(-0.12, 0.12), vy: rand(-0.18, 0.18),
      a: rand(0.15, 0.55), hue: Math.random() < 0.5 ? 186 : 266
    }));
  }

  function draw() {
    ctx.clearRect(0, 0, w, h);
    // soft beams
    const g = ctx.createLinearGradient(0, 0, w, h);
    g.addColorStop(0, 'rgba(77,231,247,0.04)');
    g.addColorStop(0.5, 'rgba(155,108,255,0.03)');
    g.addColorStop(1, 'rgba(23,241,209,0.04)');
    ctx.fillStyle = g;
    ctx.fillRect(0, 0, w, h);

    for (let i = 0; i < points.length; i++) {
      const p = points[i];
      p.x += p.vx; p.y += p.vy;
      if (p.x < -10) p.x = w + 10; if (p.x > w + 10) p.x = -10;
      if (p.y < -10) p.y = h + 10; if (p.y > h + 10) p.y = -10;
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      ctx.fillStyle = `hsla(${p.hue}, 90%, 70%, ${p.a})`;
      ctx.fill();

      for (let j = i + 1; j < points.length; j++) {
        const q = points[j];
        const dx = p.x - q.x, dy = p.y - q.y;
        const d2 = dx * dx + dy * dy;
        if (d2 < 110 * 110) {
          const alpha = (1 - Math.sqrt(d2) / 110) * 0.12;
          ctx.strokeStyle = `rgba(120, 210, 255, ${alpha})`;
          ctx.lineWidth = 1;
          ctx.beginPath();
          ctx.moveTo(p.x, p.y);
          ctx.lineTo(q.x, q.y);
          ctx.stroke();
        }
      }
    }
    raf = requestAnimationFrame(draw);
  }

  resize();
  draw();
  window.addEventListener('resize', () => { cancelAnimationFrame(raf); resize(); draw(); }, { passive: true });
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) cancelAnimationFrame(raf); else { cancelAnimationFrame(raf); draw(); }
  });
})();