/**
 * profile-check.js — Installer Onboarding Completeness Guard
 * Priority #4 fix: blocks proposal generation until logo, brand colour,
 * and contact number are set. Skips Nova Metrics own account (installer_id = 1).
 *
 * Add this to solar-intelligence.html before </body>:
 *   <script src="profile-check.js"></script>
 */

(function () {
  'use strict';

  const DEFAULT_COLOR = '#0A2540';
  const NOVA_METRICS_ID = 1;

  /* ── 1. INJECT CSS ─────────────────────────────────────────────────────── */
  const style = document.createElement('style');
  style.textContent = `
    .ob-overlay{position:fixed;inset:0;background:rgba(7,9,14,.93);z-index:600;
      display:none;align-items:center;justify-content:center;padding:20px;}
    .ob-overlay.on{display:flex;}
    .ob-modal{background:#111620;border:1px solid rgba(255,215,0,.28);border-radius:16px;
      padding:36px;width:100%;max-width:500px;position:relative;animation:obSlide .25s ease;}
    @keyframes obSlide{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}
    .ob-modal::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;
      background:linear-gradient(90deg,#FFD700,transparent);border-radius:16px 16px 0 0;}
    .ob-title{font-family:'DM Serif Display',serif;font-size:1.45rem;color:#edf1f6;margin-bottom:5px;}
    .ob-sub{font-size:12px;color:#7a95af;margin-bottom:18px;line-height:1.65;}
    .ob-bar-wrap{height:7px;background:rgba(255,255,255,.06);border-radius:4px;margin-bottom:20px;overflow:hidden;}
    .ob-bar-fill{height:100%;background:#FFD700;border-radius:4px;transition:width .35s;}
    .ob-pct{font-size:10px;color:#7a95af;text-align:right;margin-top:4px;margin-bottom:14px;}
    .ob-item{display:flex;align-items:flex-start;gap:12px;padding:13px 14px;border-radius:10px;
      border:1px solid rgba(255,255,255,.08);background:rgba(255,255,255,.03);margin-bottom:8px;transition:all .2s;}
    .ob-item.done{border-color:rgba(52,211,153,.28);background:rgba(52,211,153,.06);}
    .ob-icon{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;
      font-size:15px;flex-shrink:0;background:rgba(255,255,255,.06);}
    .ob-item.done .ob-icon{background:rgba(52,211,153,.14);}
    .ob-body{flex:1;min-width:0;}
    .ob-label{font-size:13px;font-weight:500;color:#edf1f6;}
    .ob-item.done .ob-label{color:#34d399;}
    .ob-hint{font-size:11px;color:#7a95af;margin-top:2px;line-height:1.5;}
    .ob-field{margin-top:9px;}
    .ob-field input[type=url],.ob-field input[type=tel],.ob-field input[type=text]{
      width:100%;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.12);
      color:#edf1f6;padding:9px 12px;border-radius:8px;font-size:13px;
      font-family:'DM Sans',sans-serif;transition:border-color .2s;}
    .ob-field input:focus{outline:none;border-color:#FFD700;}
    .ob-field input::placeholder{color:rgba(255,255,255,.2);}
    .ob-color-row{display:flex;gap:8px;align-items:center;margin-top:9px;}
    .ob-color-row input[type=color]{width:40px;height:36px;padding:2px;border-radius:7px;
      border:1px solid rgba(255,255,255,.12);background:none;cursor:pointer;flex-shrink:0;}
    .ob-color-row input[type=text]{flex:1;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.12);
      color:#edf1f6;padding:9px 12px;border-radius:8px;font-size:13px;font-family:'DM Sans',sans-serif;}
    .ob-color-row input[type=text]:focus{outline:none;border-color:#FFD700;}
    .ob-save{background:#FFD700;color:#0B1F3A;border:none;padding:13px 28px;border-radius:9px;
      font-weight:700;font-size:14px;font-family:'DM Sans',sans-serif;cursor:pointer;
      width:100%;margin-top:18px;transition:all .2s;}
    .ob-save:hover:not(:disabled){background:#fff;}
    .ob-save:disabled{background:rgba(255,255,255,.08);color:rgba(255,255,255,.25);cursor:not-allowed;}
    .ob-skip{display:block;text-align:center;font-size:11px;color:#7a95af;margin-top:10px;
      cursor:pointer;background:none;border:none;font-family:'DM Sans',sans-serif;width:100%;padding:4px;}
    .ob-skip:hover{color:#edf1f6;}
    .ob-saving{display:inline-block;width:13px;height:13px;border:2px solid #0B1F3A;
      border-top-color:transparent;border-radius:50%;animation:spin .7s linear infinite;vertical-align:middle;margin-right:6px;}

    /* profile-incomplete warning banner inside the proposal tab */
    .ob-warn-bar{display:none;background:rgba(248,113,113,.08);border:1px solid rgba(248,113,113,.25);
      border-radius:10px;padding:12px 16px;margin-bottom:14px;font-size:12px;color:#f87171;line-height:1.6;}
    .ob-warn-bar.on{display:flex;align-items:center;gap:10px;}
    .ob-warn-bar button{background:rgba(248,113,113,.15);border:1px solid rgba(248,113,113,.3);
      color:#f87171;font-size:11px;font-weight:600;font-family:'DM Sans',sans-serif;
      padding:5px 12px;border-radius:7px;cursor:pointer;flex-shrink:0;white-space:nowrap;}
    .ob-warn-bar button:hover{background:rgba(248,113,113,.25);}
  `;
  document.head.appendChild(style);

  /* ── 2. INJECT MODAL HTML ───────────────────────────────────────────────── */
  const modalHtml = `
  <div id="ob-overlay" class="ob-overlay" role="dialog" aria-modal="true" aria-labelledby="ob-title">
    <div class="ob-modal">
      <div class="ob-title" id="ob-title">Set up your installer profile</div>
      <div class="ob-sub">
        Your logo, brand colour, and contact number appear on every proposal you send to clients.
        Complete your profile before generating your first proposal.
      </div>
      <div class="ob-bar-wrap"><div class="ob-bar-fill" id="ob-bar" style="width:0%"></div></div>
      <div class="ob-pct" id="ob-pct">0 of 3 complete</div>

      <!-- Logo -->
      <div class="ob-item" id="ob-item-logo">
        <div class="ob-icon">🖼</div>
        <div class="ob-body">
          <div class="ob-label">Company logo</div>
          <div class="ob-hint">URL to your logo (PNG or JPG). Appears on every proposal cover.</div>
          <div class="ob-field">
            <input type="url" id="ob-logo" placeholder="https://your-domain.com/logo.png" oninput="obUpdate()" />
          </div>
        </div>
      </div>

      <!-- Brand colour -->
      <div class="ob-item" id="ob-item-color">
        <div class="ob-icon">🎨</div>
        <div class="ob-body">
          <div class="ob-label">Brand colour</div>
          <div class="ob-hint">Your primary brand colour — used for proposal headers and accents.</div>
          <div class="ob-color-row">
            <input type="color" id="ob-color-pick" value="#0A2540" oninput="obSyncHex()" />
            <input type="text" id="ob-color-hex" value="#0A2540" maxlength="7" placeholder="#RRGGBB" oninput="obSyncPick()" />
          </div>
        </div>
      </div>

      <!-- Contact number -->
      <div class="ob-item" id="ob-item-phone">
        <div class="ob-icon">📞</div>
        <div class="ob-body">
          <div class="ob-label">Contact number</div>
          <div class="ob-hint">Printed on every proposal footer and handover certificate.</div>
          <div class="ob-field">
            <input type="tel" id="ob-phone" placeholder="+27 82 000 0000" oninput="obUpdate()" />
          </div>
        </div>
      </div>

      <button class="ob-save" id="ob-save-btn" onclick="obSave()" disabled>Save &amp; Continue</button>
      <button class="ob-skip" onclick="obSkip()">
        Skip for now — proposals will use default Nova Metrics branding until you complete this
      </button>
    </div>
  </div>

  <!-- Warning bar injected inside the proposal tab -->
  <div id="ob-warn-bar" class="ob-warn-bar">
    <span>⚠ Your profile is incomplete — proposals will go out with default Nova Metrics branding.</span>
    <button onclick="obOpen()">Complete Profile</button>
  </div>
  `;
  document.body.insertAdjacentHTML('beforeend', modalHtml);

  /* ── 3. CORE LOGIC ──────────────────────────────────────────────────────── */

  function obProfileComplete() {
    const inst = window.installer;
    if (!inst) return true; // not loaded yet, don't block
    if (inst.installer_id === NOVA_METRICS_ID) return true; // skip Nova Metrics account

    const hasLogo  = !!(inst.logo_url && inst.logo_url.trim());
    const hasColor = !!(inst.primary_color && inst.primary_color.toUpperCase() !== DEFAULT_COLOR);
    const hasPhone = !!(inst.contact_number && inst.contact_number.trim());
    return hasLogo && hasColor && hasPhone;
  }

  function obScore() {
    const inst = window.installer;
    if (!inst) return 3;
    const hasLogo  = !!(inst.logo_url && inst.logo_url.trim());
    const hasColor = !!(inst.primary_color && inst.primary_color.toUpperCase() !== DEFAULT_COLOR);
    const hasPhone = !!(inst.contact_number && inst.contact_number.trim());
    return [hasLogo, hasColor, hasPhone].filter(Boolean).length;
  }

  window.obOpen = function () {
    const inst = window.installer || {};
    if (inst.logo_url)       document.getElementById('ob-logo').value        = inst.logo_url;
    if (inst.primary_color) {
      document.getElementById('ob-color-pick').value = inst.primary_color;
      document.getElementById('ob-color-hex').value  = inst.primary_color;
    }
    if (inst.contact_number) document.getElementById('ob-phone').value       = inst.contact_number;
    obUpdate();
    document.getElementById('ob-overlay').classList.add('on');
  };

  window.obSkip = function () {
    document.getElementById('ob-overlay').classList.remove('on');
    obRefreshWarnBar();
    if (window.toast) window.toast('⚠ Profile incomplete — using default Nova Metrics branding on proposals', true);
  };

  window.obSyncHex = function () {
    document.getElementById('ob-color-hex').value = document.getElementById('ob-color-pick').value;
    obUpdate();
  };

  window.obSyncPick = function () {
    const v = document.getElementById('ob-color-hex').value;
    if (/^#[0-9A-Fa-f]{6}$/.test(v)) document.getElementById('ob-color-pick').value = v;
    obUpdate();
  };

  window.obUpdate = function () {
    const logo  = document.getElementById('ob-logo').value.trim();
    const hex   = document.getElementById('ob-color-hex').value.trim();
    const phone = document.getElementById('ob-phone').value.trim();

    const hasLogo  = logo.length > 5;
    const hasColor = /^#[0-9A-Fa-f]{6}$/i.test(hex) && hex.toUpperCase() !== DEFAULT_COLOR;
    const hasPhone = phone.length > 6;

    document.getElementById('ob-item-logo').className  = 'ob-item' + (hasLogo  ? ' done' : '');
    document.getElementById('ob-item-color').className = 'ob-item' + (hasColor ? ' done' : '');
    document.getElementById('ob-item-phone').className = 'ob-item' + (hasPhone ? ' done' : '');

    const score = [hasLogo, hasColor, hasPhone].filter(Boolean).length;
    const pct   = Math.round(score / 3 * 100);
    document.getElementById('ob-bar').style.width = pct + '%';
    document.getElementById('ob-pct').textContent = score + ' of 3 complete';
    document.getElementById('ob-save-btn').disabled = score === 0;
  };

  window.obSave = async function () {
    const logo  = document.getElementById('ob-logo').value.trim()  || null;
    const hex   = document.getElementById('ob-color-hex').value.trim();
    const phone = document.getElementById('ob-phone').value.trim() || null;
    const btn   = document.getElementById('ob-save-btn');

    btn.disabled = true;
    btn.innerHTML = '<span class="ob-saving"></span>Saving…';

    const { data: { session } } = await window.supabaseClient.auth.getSession();
    const token = session ? session.access_token : window.SUPA_ANON;

    const updates = {};
    if (logo)  updates.logo_url       = logo;
    if (hex && /^#[0-9A-Fa-f]{6}$/i.test(hex)) updates.primary_color = hex;
    if (phone) updates.contact_number = phone;

    try {
      const res = await fetch(window.SUPA_URL + '/rest/v1/installers?installer_id=eq.' + window.installer.installer_id, {
        method: 'PATCH',
        headers: {
          'apikey': window.SUPA_ANON,
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json',
          'Prefer': 'return=minimal'
        },
        body: JSON.stringify(updates)
      });
      if (!res.ok) throw new Error('Save failed (' + res.status + ')');

      Object.assign(window.installer, updates);
      document.getElementById('ob-overlay').classList.remove('on');
      obRefreshWarnBar();
      if (window.toast) window.toast('✓ Profile saved — proposals will use your branding');
      if (window.showHwBanner) window.showHwBanner();
    } catch (e) {
      if (window.toast) window.toast('✗ ' + e.message, true);
    }

    btn.disabled = false;
    btn.textContent = 'Save & Continue';
  };

  function obRefreshWarnBar() {
    const bar = document.getElementById('ob-warn-bar');
    if (!bar) return;
    const inst = window.installer;
    if (!inst || inst.installer_id === NOVA_METRICS_ID) { bar.classList.remove('on'); return; }
    bar.classList.toggle('on', !obProfileComplete());
  }

  /* ── 4. HOOK INTO showApp ───────────────────────────────────────────────── */
  // Wait for showApp to be defined (it's in a script block in the same file),
  // then wrap it so we trigger the onboarding check after it runs.
  function patchShowApp() {
    const orig = window.showApp;
    if (typeof orig !== 'function') {
      // Not ready yet — try again in a tick
      setTimeout(patchShowApp, 50);
      return;
    }
    window.showApp = function () {
      orig.apply(this, arguments);
      const inst = window.installer;
      if (!inst || inst.installer_id === NOVA_METRICS_ID) return;

      // Pre-fill fields with any existing values
      if (inst.logo_url)       document.getElementById('ob-logo').value        = inst.logo_url;
      if (inst.primary_color) {
        document.getElementById('ob-color-pick').value = inst.primary_color;
        document.getElementById('ob-color-hex').value  = inst.primary_color;
      }
      if (inst.contact_number) document.getElementById('ob-phone').value       = inst.contact_number;
      obUpdate();
      obRefreshWarnBar();

      if (!obProfileComplete()) {
        // Short delay so the app screen renders first
        setTimeout(() => document.getElementById('ob-overlay').classList.add('on'), 300);
      }
    };
  }

  /* ── 5. HOOK INTO generateProposal ─────────────────────────────────────── */
  function patchGenerateProposal() {
    const orig = window.generateProposal;
    if (typeof orig !== 'function') {
      setTimeout(patchGenerateProposal, 50);
      return;
    }
    window.generateProposal = function () {
      const inst = window.installer;
      if (inst && inst.installer_id !== NOVA_METRICS_ID && !obProfileComplete()) {
        obOpen();
        if (window.toast) window.toast('⚠ Complete your profile before generating proposals', true);
        return;
      }
      return orig.apply(this, arguments);
    };
  }

  /* ── 6. INJECT WARN BAR INTO PROPOSAL TAB ─────────────────────────────── */
  // Moves the warn bar div inside tab-proposal after DOM ready
  function injectWarnBar() {
    const tab = document.getElementById('tab-proposal');
    const bar = document.getElementById('ob-warn-bar');
    if (!tab || !bar) { setTimeout(injectWarnBar, 100); return; }
    tab.insertBefore(bar, tab.firstChild);
  }

  /* ── 7. BOOT ────────────────────────────────────────────────────────────── */
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      injectWarnBar();
      patchShowApp();
      patchGenerateProposal();
    });
  } else {
    injectWarnBar();
    patchShowApp();
    patchGenerateProposal();
  }

})();
