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

  // Scroll progress
  const progress = qs('#scrollProgress');
  const onScroll = () => {
    if (!progress) return;
    const doc = document.documentElement;
    const max = doc.scrollHeight - doc.clientHeight;
    const pct = max > 0 ? (doc.scrollTop / max) * 100 : 0;
    progress.style.width = pct + '%';
  };
  if (progress) {
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', onScroll, { passive: true });
  }

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
      // Safety net: if the observer never fired at all (offscreen/unpainted
      // document, restricted environments), never leave content invisible.
      setTimeout(() => {
        if (!qsa('.reveal.is-visible, [data-reveal].is-visible').length) {
          revealEls.forEach(el => el.classList.add('is-visible'));
        }
      }, 4000);
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

    // Magnetic buttons (subtle)
    qsa('.magnetic.button, .nav-cta.magnetic').forEach(btn => {
      let raf = 0;
      btn.addEventListener('mousemove', (e) => {
        const r = btn.getBoundingClientRect();
        const x = e.clientX - (r.left + r.width / 2);
        const y = e.clientY - (r.top + r.height / 2);
        cancelAnimationFrame(raf);
        raf = requestAnimationFrame(() => {
          btn.style.transform = `translate(${(x * 0.08).toFixed(2)}px, ${(y * 0.12).toFixed(2)}px)`;
        });
      });
      const reset = () => { cancelAnimationFrame(raf); btn.style.transform = ''; };
      btn.addEventListener('mouseleave', reset);
      btn.addEventListener('blur', reset);
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
      const finish = () => { el.textContent = target + suffix; };
      const step = (now) => {
        const p = Math.min(1, (now - start) / dur);
        const eased = 1 - Math.pow(1 - p, 3);
        el.textContent = Math.round(target * eased) + suffix;
        if (p < 1) requestAnimationFrame(step);
        else finish();
      };
      requestAnimationFrame(step);
      // Guarantee: never leave a counter mid-animation or at zero.
      setTimeout(finish, dur + 250);
    };
    if (!('IntersectionObserver' in window)) counters.forEach(animate);
    else {
      const cio = new IntersectionObserver((entries) => {
        entries.forEach(entry => { if (entry.isIntersecting) { animate(entry.target); cio.unobserve(entry.target); } });
      }, { threshold: 0.5 });
      counters.forEach(el => cio.observe(el));
      // Safety net: never leave counters at zero if the observer never fires.
      setTimeout(() => {
        counters.forEach(el => {
          if (el.textContent.trim() === '' || el.textContent.trim() === '0') animate(el);
        });
      }, 4000);
    }
  }

  // ============================================================
  // Live typing terminal (hero) — cycles through demo commands
  // ============================================================
  const typeTarget = qs('#typeTarget');
  if (typeTarget) {
    const lines = [
      'hnstyle royal',
      'hnsuggest "git project"',
      'hnports',
      'hndoctor',
      'hnhistory-search ssh'
    ];
    if (reduce) {
      typeTarget.textContent = lines[0];
    } else {
      let li = 0, ci = 0, deleting = false;
      const tick = () => {
        const line = lines[li];
        if (!deleting) {
          ci++;
          typeTarget.textContent = line.slice(0, ci);
          if (ci >= line.length) { deleting = true; setTimeout(tick, 1600); return; }
          setTimeout(tick, 55 + Math.random() * 45);
        } else {
          ci--;
          typeTarget.textContent = line.slice(0, ci);
          if (ci <= 0) { deleting = false; li = (li + 1) % lines.length; setTimeout(tick, 350); return; }
          setTimeout(tick, 26);
        }
      };
      setTimeout(tick, 900);
    }
  }

  // ============================================================
  // Prism profile gallery — select a profile, preview its rail
  // ============================================================
  const prismGrid = qs('#prismGrid');
  if (prismGrid) {
    const rail = qs('#prismRail');
    const nameEl = qs('#prismName');
    const rgbEl = qs('#prismRgb');
    const cmdEl = qs('#prismCmd');
    const cards = qsa('.prism-card', prismGrid);
    const select = (card) => {
      cards.forEach(c => { c.classList.remove('is-active'); c.setAttribute('aria-pressed', 'false'); });
      card.classList.add('is-active');
      card.setAttribute('aria-pressed', 'true');
      if (rail) rail.style.background = card.getAttribute('data-rail') || '';
      if (nameEl) nameEl.textContent = card.getAttribute('data-name') || '';
      if (rgbEl) rgbEl.textContent = card.getAttribute('data-rgb') || '';
      if (cmdEl) cmdEl.textContent = 'hnstyle ' + (card.getAttribute('data-key') || '');
    };
    cards.forEach(card => {
      card.setAttribute('aria-pressed', 'false');
      card.addEventListener('click', () => select(card));
    });
    const initial = qs('.prism-card.is-active', prismGrid) || cards[0];
    if (initial) {
      // default selection without animation classes
      cards.forEach(c => c.classList.remove('is-active'));
      initial.classList.add('is-active');
      initial.setAttribute('aria-pressed', 'true');
      if (rail) rail.style.background = initial.getAttribute('data-rail') || '';
      if (nameEl) nameEl.textContent = initial.getAttribute('data-name') || '';
      if (rgbEl) rgbEl.textContent = initial.getAttribute('data-rgb') || '';
      if (cmdEl) cmdEl.textContent = 'hnstyle ' + (initial.getAttribute('data-key') || '');
    }
  }

  // ============================================================
  // Command explorer — live search + category chips
  // ============================================================
  const cmdGrid = qs('#cmdGrid');
  if (cmdGrid) {
    const input = qs('#cmdSearch');
    const countEl = qs('#cmdCount');
    const emptyEl = qs('#cmdEmpty');
    const chips = qsa('.chip');
    const cards = qsa('.cmd-card', cmdGrid);
    let cat = 'all';

    const apply = () => {
      const q = (input && input.value ? input.value : '').trim().toLowerCase();
      let shown = 0;
      cards.forEach(card => {
        const catOk = cat === 'all' || card.getAttribute('data-cat') === cat;
        const hay = ((card.getAttribute('data-text') || '') + ' ' + card.textContent).toLowerCase();
        const qOk = !q || hay.indexOf(q) !== -1;
        const ok = catOk && qOk;
        card.classList.toggle('is-hidden', !ok);
        if (ok) {
          shown++;
          card.classList.remove('is-match');
          // restart entrance animation
          void card.offsetWidth;
          card.classList.add('is-match');
        }
      });
      if (countEl) countEl.textContent = shown + (shown === 1 ? ' entry' : ' entries');
      if (emptyEl) emptyEl.hidden = shown !== 0;
    };

    if (input) {
      input.addEventListener('input', apply);
      input.addEventListener('search', apply);
    }
    chips.forEach(chip => {
      chip.addEventListener('click', () => {
        chips.forEach(c => c.classList.remove('is-active'));
        chip.classList.add('is-active');
        cat = chip.getAttribute('data-cat') || 'all';
        apply();
      });
    });
    apply();
  }

  // ============================================================
  // Copy-to-clipboard buttons ([data-copy-text] / [data-copy-target])
  // ============================================================
  const copyButtons = qsa('.copy-btn');
  if (copyButtons.length) {
    const fallbackCopy = (text) => {
      const ta = document.createElement('textarea');
      ta.value = text;
      ta.setAttribute('readonly', '');
      ta.style.position = 'fixed';
      ta.style.opacity = '0';
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand('copy'); } catch (e) { /* noop */ }
      document.body.removeChild(ta);
    };
    copyButtons.forEach(btn => {
      const original = btn.textContent;
      btn.addEventListener('click', () => {
        let text = btn.getAttribute('data-copy-text') || '';
        const targetSel = btn.getAttribute('data-copy-target');
        if (targetSel) {
          const target = qs(targetSel);
          if (target) text = target.textContent.trim();
        }
        if (!text) return;
        const done = () => {
          btn.textContent = 'Copied ✓';
          btn.classList.add('is-copied');
          setTimeout(() => { btn.textContent = original; btn.classList.remove('is-copied'); }, 1600);
        };
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(text).then(done, () => { fallbackCopy(text); done(); });
        } else {
          fallbackCopy(text);
          done();
        }
      });
    });
  }

  // ============================================================
  // Install mode tabs
  // ============================================================
  const modeExplorer = qs('.mode-explorer');
  if (modeExplorer) {
    const tabs = qsa('.mode-tab', modeExplorer);
    const panels = qsa('.mode-panel', modeExplorer);
    const activate = (mode) => {
      tabs.forEach(t => {
        const on = t.getAttribute('data-mode') === mode;
        t.classList.toggle('is-active', on);
        t.setAttribute('aria-selected', String(on));
        t.tabIndex = on ? 0 : -1;
      });
      panels.forEach(p => {
        const on = p.getAttribute('data-mode') === mode;
        p.hidden = !on;
        p.classList.toggle('is-active', on);
      });
      modeExplorer.classList.remove('is-switching');
      void modeExplorer.offsetWidth;
      modeExplorer.classList.add('is-switching');
    };
    tabs.forEach((tab, i) => {
      tab.addEventListener('click', () => activate(tab.getAttribute('data-mode')));
      tab.addEventListener('keydown', (e) => {
        let next = -1;
        if (e.key === 'ArrowRight') next = (i + 1) % tabs.length;
        else if (e.key === 'ArrowLeft') next = (i - 1 + tabs.length) % tabs.length;
        else if (e.key === 'Home') next = 0;
        else if (e.key === 'End') next = tabs.length - 1;
        if (next >= 0) {
          e.preventDefault();
          tabs[next].focus();
          activate(tabs[next].getAttribute('data-mode'));
        }
      });
    });
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
    const count = Math.max(28, Math.min(110, Math.floor((w * h) / 22000)));
    points = Array.from({ length: count }, () => ({
      x: rand(0, w), y: rand(0, h), r: rand(0.4, 1.9),
      vx: rand(-0.12, 0.12), vy: rand(-0.18, 0.18),
      a: rand(0.15, 0.6), hue: Math.random() < 0.4 ? 186 : (Math.random() < 0.7 ? 266 : 160)
    }));
  }

  function draw() {
    ctx.clearRect(0, 0, w, h);
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
        if (d2 < 120 * 120) {
          const alpha = (1 - Math.sqrt(d2) / 120) * 0.13;
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
