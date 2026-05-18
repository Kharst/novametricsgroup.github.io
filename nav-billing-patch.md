# Billing Nav Patch — Manual Steps

## prposal_portal.html
Find this exact line:
```
<a href="#" class="nav-a hi" id="navInstallerName">Nova Metrics</a>
```
Insert this BEFORE that line:
```html
<a href="billing.html" class="new-calc-topbtn" style="background:rgba(255,215,0,.10);border:1px solid rgba(255,215,0,.25);color:#d4a800;font-size:11px;padding:5px 10px;">💳 Billing</a>
```

## job-portal.html
Find this exact line:
```
<a href="prposal_portal.html" style="...">← Proposal Portal</a>
```
Insert this AFTER that line:
```html
<a href="billing.html" style="font-family:var(--mono);font-size:11px;background:transparent;border:1px solid var(--border2);color:var(--text2);padding:5px 12px;border-radius:4px;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px;transition:all .15s" onmouseover="this.style.borderColor='var(--amber)';this.style.color='var(--amber)'" onmouseout="this.style.borderColor='var(--border2)';this.style.color='var(--text2)'">💳 Billing</a>
```
