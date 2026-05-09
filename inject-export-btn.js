/* inject-export-btn.js — adds data export button to proposal portal sidebar */
(function(){
  var style = document.createElement('style');
  style.textContent = [
    '.sidebar-footer{flex-shrink:0;padding:8px 9px;border-top:1px solid rgba(255,255,255,.07);}',
    '.sidebar-export-btn{display:flex;align-items:center;gap:7px;width:100%;padding:8px 10px;border-radius:7px;background:transparent;border:1px solid transparent;color:#7a95af;font-family:"DM Sans",sans-serif;font-size:10px;font-weight:600;cursor:pointer;transition:all .2s;text-decoration:none;letter-spacing:.02em;}',
    '.sidebar-export-btn:hover{background:rgba(255,255,255,.05);border-color:rgba(255,255,255,.1);color:#f0f4f8;}',
    '.sidebar-export-btn svg{width:12px;height:12px;flex-shrink:0;opacity:.4;transition:opacity .2s;}',
    '.sidebar-export-btn:hover svg{opacity:.85;}',
    '.sidebar-export-pulse{width:5px;height:5px;border-radius:50%;background:rgba(122,200,248,.55);flex-shrink:0;animation:pulse-exp 2.5s ease-in-out infinite;}',
    '@keyframes pulse-exp{0%,100%{opacity:.55}50%{opacity:1}}'
  ].join('');
  document.head.appendChild(style);

  function addExportBtn() {
    var sidebar = document.querySelector('.sidebar');
    if (!sidebar || document.getElementById('sidebarExportFooter')) return;
    var footer = document.createElement('div');
    footer.className = 'sidebar-footer';
    footer.id = 'sidebarExportFooter';
    footer.innerHTML =
      '<a href="data-export.html" class="sidebar-export-btn" title="Download all your data — proposals, site visits, installations, handovers">' +
        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
          '<path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>' +
          '<polyline points="7 10 12 15 17 10"/>' +
          '<line x1="12" y1="15" x2="12" y2="3"/>' +
        '</svg>' +
        '<span style="flex:1">Export My Data</span>' +
        '<div class="sidebar-export-pulse"></div>' +
      '</a>';
    sidebar.appendChild(footer);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', addExportBtn);
  } else {
    addExportBtn();
  }
})();
