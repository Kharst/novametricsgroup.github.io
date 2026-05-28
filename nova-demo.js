/**
 * nova-demo.js — Demo mode for Nova Metrics
 * Add ?demo=1 to any page URL to activate.
 * Shows realistic placeholder data so new users see the full product before signing up.
 */
(function(){
  window.NOVA_DEMO = new URLSearchParams(window.location.search).get('demo') === '1';
  if(!window.NOVA_DEMO) return;

  /* ── SHARED DEMO DATA ─────────────────────────────── */

  const now = new Date();
  function daysAgo(d){ const x=new Date(now); x.setDate(x.getDate()-d); return x.toISOString(); }

  /* Realistic South African solar installer */
  window.DEMO_INSTALLER = {
    installer_id: 'demo-installer-001',
    installer_name: 'Bright Future Solar',
    contact_email: 'info@brightfuturesolar.co.za',
    contact_number: '011 234 5678',
    logo_url: null,
    primary_color: '#FFD700',
    secondary_color: '#1a2a4a',
    accent_color: '#2ecc8a',
    terms_accepted_at: '2025-01-01T00:00:00Z',
    terms_version: '1.0'
  };

  /* 18 proposals — mix of stages, residential + commercial */
  window.DEMO_PROPOSALS = [
    { ai_id:1001, client_name:'Sipho Dlamini',      client_email:'sipho.d@gmail.com',     location:'Johannesburg, Gauteng',     system_size_kw:10,  battery_capacity_kwh:10, panel_number:24, total_cost:185000,  annual_savings:48000, monthly_savings:4000, payback_years:3.9, job_status:'handover_completed',      proposal_status:'accepted',  email_sent_at:daysAgo(85), proposal_viewed_at:daysAgo(84), client_engaged:true,  won_at:daysAgo(83), pdf_url:'demo://pdf',  created_at:daysAgo(90),  site_visit_completed_at:daysAgo(82), installation_completed_at:daysAgo(55), handover_completed_at:daysAgo(50), sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(84) },
    { ai_id:1002, client_name:'Priya Naidoo',       client_email:'priya.n@webmail.co.za', location:'Pretoria, Gauteng',          system_size_kw:8,   battery_capacity_kwh:5,  panel_number:20, total_cost:148000,  annual_savings:37000, monthly_savings:3100, payback_years:4.0, job_status:'installation_completed',  proposal_status:'accepted',  email_sent_at:daysAgo(70), proposal_viewed_at:daysAgo(69), client_engaged:true,  won_at:daysAgo(68), pdf_url:'demo://pdf',  created_at:daysAgo(75),  site_visit_completed_at:daysAgo(65), installation_completed_at:daysAgo(30), handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(69) },
    { ai_id:1003, client_name:'Johan van der Berg', client_email:'jvdb@vodamail.co.za',   location:'Sandton, Gauteng',           system_size_kw:20,  battery_capacity_kwh:20, panel_number:48, total_cost:380000,  annual_savings:92000, monthly_savings:7700, payback_years:4.1, job_status:'installation_in_progress',proposal_status:'accepted',  email_sent_at:daysAgo(60), proposal_viewed_at:daysAgo(59), client_engaged:true,  won_at:daysAgo(58), pdf_url:'demo://pdf',  created_at:daysAgo(65),  site_visit_completed_at:daysAgo(55), installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(59) },
    { ai_id:1004, client_name:'Fatima Moosa',       client_email:'fatima.m@mweb.co.za',   location:'Centurion, Gauteng',         system_size_kw:6,   battery_capacity_kwh:5,  panel_number:16, total_cost:112000,  annual_savings:28000, monthly_savings:2300, payback_years:4.0, job_status:'installation_scheduled',  proposal_status:'accepted',  email_sent_at:daysAgo(45), proposal_viewed_at:daysAgo(44), client_engaged:true,  won_at:daysAgo(42), pdf_url:'demo://pdf',  created_at:daysAgo(50),  site_visit_completed_at:daysAgo(40), installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(44) },
    { ai_id:1005, client_name:'Themba Khumalo',     client_email:'t.khumalo@gmail.com',   location:'Midrand, Gauteng',           system_size_kw:15,  battery_capacity_kwh:15, panel_number:36, total_cost:280000,  annual_savings:70000, monthly_savings:5800, payback_years:4.0, job_status:'site_visit_completed',    proposal_status:'accepted',  email_sent_at:daysAgo(30), proposal_viewed_at:daysAgo(28), client_engaged:true,  won_at:daysAgo(27), pdf_url:'demo://pdf',  created_at:daysAgo(35),  site_visit_completed_at:daysAgo(20), installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(28) },
    { ai_id:1006, client_name:'Anele Botha',        client_email:'anele.b@icloud.com',    location:'Fourways, Gauteng',          system_size_kw:10,  battery_capacity_kwh:10, panel_number:24, total_cost:192000,  annual_savings:49000, monthly_savings:4100, payback_years:3.9, job_status:'site_visit_scheduled',    proposal_status:'accepted',  email_sent_at:daysAgo(20), proposal_viewed_at:daysAgo(18), client_engaged:true,  won_at:daysAgo(16), pdf_url:'demo://pdf',  created_at:daysAgo(25),  site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(18) },
    { ai_id:1007, client_name:'Ruan Pieterse',      client_email:'r.pieterse@hotmail.com',location:'Roodepoort, Gauteng',        system_size_kw:8,   battery_capacity_kwh:5,  panel_number:20, total_cost:145000,  annual_savings:36000, monthly_savings:3000, payback_years:4.0, job_status:'accepted',                proposal_status:'accepted',  email_sent_at:daysAgo(12), proposal_viewed_at:daysAgo(10), client_engaged:true,  won_at:daysAgo(9),  pdf_url:'demo://pdf',  created_at:daysAgo(15),  site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(10) },
    { ai_id:1008, client_name:'Lungisa Mthembu',    client_email:'l.mthembu@gmail.com',   location:'Soweto, Gauteng',            system_size_kw:5,   battery_capacity_kwh:5,  panel_number:12, total_cost:98000,   annual_savings:24000, monthly_savings:2000, payback_years:4.1, job_status:null,                      proposal_status:'pending',   email_sent_at:daysAgo(8),  proposal_viewed_at:daysAgo(7),  client_engaged:false, won_at:null,       pdf_url:'demo://pdf',  created_at:daysAgo(10),  site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:daysAgo(8), email_opened_at:null },
    { ai_id:1009, client_name:'Nompumelelo Zulu',   client_email:'nom.z@yahoo.com',       location:'Randburg, Gauteng',          system_size_kw:12,  battery_capacity_kwh:10, panel_number:28, total_cost:225000,  annual_savings:56000, monthly_savings:4700, payback_years:4.0, job_status:null,                      proposal_status:'pending',   email_sent_at:daysAgo(6),  proposal_viewed_at:daysAgo(5),  client_engaged:false, won_at:null,       pdf_url:'demo://pdf',  created_at:daysAgo(8),   site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(5) },
    { ai_id:1010, client_name:'Gareth Ferreira',    client_email:'g.ferreira@gmail.com',  location:'Bryanston, Gauteng',         system_size_kw:30,  battery_capacity_kwh:20, panel_number:68, total_cost:540000,  annual_savings:138000,monthly_savings:11500,payback_years:3.9, job_status:null,                      proposal_status:'pending',   email_sent_at:daysAgo(5),  proposal_viewed_at:daysAgo(4),  client_engaged:false, won_at:null,       pdf_url:'demo://pdf',  created_at:daysAgo(7),   site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(4) },
    { ai_id:1011, client_name:'Zanele Kgosana',     client_email:'z.kgos@live.co.za',     location:'Tembisa, Gauteng',           system_size_kw:6,   battery_capacity_kwh:0,  panel_number:16, total_cost:82000,   annual_savings:20000, monthly_savings:1700, payback_years:4.1, job_status:null,                      proposal_status:'pending',   email_sent_at:daysAgo(4),  proposal_viewed_at:null,        client_engaged:false, won_at:null,       pdf_url:'demo://pdf',  created_at:daysAgo(5),   site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:daysAgo(4), whatsapp_sent_at:null, email_opened_at:null },
    { ai_id:1012, client_name:'Heinrich Steyn',     client_email:'h.steyn@absa.co.za',    location:'Kempton Park, Gauteng',      system_size_kw:10,  battery_capacity_kwh:10, panel_number:24, total_cost:190000,  annual_savings:48000, monthly_savings:4000, payback_years:4.0, job_status:null,                      proposal_status:'pending',   email_sent_at:daysAgo(3),  proposal_viewed_at:null,        client_engaged:false, won_at:null,       pdf_url:'demo://pdf',  created_at:daysAgo(4),   site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:daysAgo(3), email_opened_at:null },
    { ai_id:1013, client_name:'Bongiwe Majola',     client_email:'b.majola@gmail.com',    location:'Alberton, Gauteng',          system_size_kw:8,   battery_capacity_kwh:5,  panel_number:20, total_cost:152000,  annual_savings:38000, monthly_savings:3200, payback_years:4.0, job_status:null,                      proposal_status:'draft',     email_sent_at:null,        proposal_viewed_at:null,        client_engaged:false, won_at:null,       pdf_url:'demo://pdf',  created_at:daysAgo(3),   site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:null },
    { ai_id:1014, client_name:'Yusuf Essop',        client_email:'y.essop@gmail.com',     location:'Springs, Gauteng',           system_size_kw:5,   battery_capacity_kwh:5,  panel_number:12, total_cost:96000,   annual_savings:24000, monthly_savings:2000, payback_years:4.0, job_status:null,                      proposal_status:'new',       email_sent_at:null,        proposal_viewed_at:null,        client_engaged:false, won_at:null,       pdf_url:null,          created_at:daysAgo(2),   site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:null },
    { ai_id:1015, client_name:'Chantel Rousseau',   client_email:'chantel.r@mweb.co.za',  location:'Edenvale, Gauteng',          system_size_kw:10,  battery_capacity_kwh:10, panel_number:24, total_cost:186000,  annual_savings:47000, monthly_savings:3900, payback_years:4.0, job_status:null,                      proposal_status:'new',       email_sent_at:null,        proposal_viewed_at:null,        client_engaged:false, won_at:null,       pdf_url:null,          created_at:daysAgo(1),   site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:null },
    { ai_id:1016, client_name:'Kgomotso Sithole',   client_email:'kgom.s@gmail.com',      location:'Benoni, Gauteng',            system_size_kw:15,  battery_capacity_kwh:15, panel_number:36, total_cost:278000,  annual_savings:69000, monthly_savings:5800, payback_years:4.0, job_status:null,                      proposal_status:'new',       email_sent_at:null,        proposal_viewed_at:null,        client_engaged:false, won_at:null,       pdf_url:null,          created_at:daysAgo(1),   site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:null },
    { ai_id:1017, client_name:'Marco Jacobs',       client_email:'m.jacobs@telkomsa.net', location:'Germiston, Gauteng',         system_size_kw:6,   battery_capacity_kwh:0,  panel_number:16, total_cost:79000,   annual_savings:19000, monthly_savings:1600, payback_years:4.2, job_status:null,                      proposal_status:'rejected',  email_sent_at:daysAgo(40), proposal_viewed_at:daysAgo(39), client_engaged:false, won_at:null,       pdf_url:'demo://pdf',  created_at:daysAgo(42),  site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(39) },
    { ai_id:1018, client_name:'Sharon Liebenberg',  client_email:'sharon.l@gmail.com',    location:'Boksburg, Gauteng',          system_size_kw:8,   battery_capacity_kwh:5,  panel_number:20, total_cost:142000,  annual_savings:35000, monthly_savings:2900, payback_years:4.1, job_status:null,                      proposal_status:'rejected',  email_sent_at:daysAgo(50), proposal_viewed_at:daysAgo(49), client_engaged:false, won_at:null,       pdf_url:'demo://pdf',  created_at:daysAgo(52),  site_visit_completed_at:null,        installation_completed_at:null,       handover_completed_at:null,          sent_at:null, whatsapp_sent_at:null, email_opened_at:daysAgo(49) },
  ];

  /* Active jobs */
  window.DEMO_JOBS = window.DEMO_PROPOSALS.filter(function(p){
    return ['accepted','site_visit_scheduled','site_visit_completed','deposit_received','materials_ordered','installation_scheduled','installation_in_progress','installation_completed','coc_issued','sseg_submitted','handover_completed'].indexOf(p.job_status) > -1;
  });

  /* Site visits */
  window.DEMO_VISITS = [
    { id:'sv-001', job_id:1001, design_changed:false, design_change_category:null, client_approval_status:'approved', created_at:daysAgo(82) },
    { id:'sv-002', job_id:1002, design_changed:false, design_change_category:null, client_approval_status:'approved', created_at:daysAgo(65) },
    { id:'sv-003', job_id:1003, design_changed:true,  design_change_category:'shading', client_approval_status:'approved', created_at:daysAgo(55) },
    { id:'sv-004', job_id:1004, design_changed:false, design_change_category:null, client_approval_status:'approved', created_at:daysAgo(40) },
    { id:'sv-005', job_id:1005, design_changed:true,  design_change_category:'roof_space', client_approval_status:'approved', created_at:daysAgo(20) },
  ];

  /* Installations */
  window.DEMO_INSTALLS = [
    { id:'in-001', job_id:1001, scheduled_date:daysAgo(60), started_at:daysAgo(57), completed_at:daysAgo(55), created_at:daysAgo(62) },
    { id:'in-002', job_id:1002, scheduled_date:daysAgo(35), started_at:daysAgo(32), completed_at:daysAgo(30), created_at:daysAgo(37) },
    { id:'in-003', job_id:1003, scheduled_date:daysAgo(5),  started_at:daysAgo(3),  completed_at:null,        created_at:daysAgo(8)  },
    { id:'in-004', job_id:1004, scheduled_date:daysAgo(-5), started_at:null,         completed_at:null,        created_at:daysAgo(10) },
  ];

  /* Handovers */
  window.DEMO_HANDOVERS = [
    { id:'ho-001', job_id:1001, handed_over_at:daysAgo(50) },
  ];

  /* Solar DB — hardware for design tool */
  window.DEMO_DB = {
    panels: [
      { id:'p1', model:'JA Solar JAM72S30 545W', watts:545, area:2.21, price:3200 },
      { id:'p2', model:'Canadian Solar CS6R-395W', watts:395, area:1.73, price:2400 },
      { id:'p3', model:'Longi Hi-MO6 580W', watts:580, area:2.28, price:3500 },
      { id:'p4', model:'Risen RSM144-7-545M', watts:545, area:2.20, price:3100 },
    ],
    inverters: [
      { id:'i1', brand:'Sunsynk', model:'Sunsynk 5kW Hybrid', ac:5,  dc:7.5, mppt:2, eff:97.5, price:22000 },
      { id:'i2', brand:'Sunsynk', model:'Sunsynk 8kW Hybrid', ac:8,  dc:12,  mppt:2, eff:97.6, price:32000 },
      { id:'i3', brand:'Deye',    model:'Deye SUN-12K-SG04LP3', ac:12, dc:18, mppt:4, eff:97.7, price:42000 },
      { id:'i4', brand:'Victron', model:'Victron MultiPlus-II 48/5000', ac:4.5, dc:7, mppt:2, eff:96.0, price:28000 },
      { id:'i5', brand:'Goodwe',  model:'Goodwe GW5048D-ES', ac:5,  dc:6.5, mppt:2, eff:97.2, price:20000 },
    ],
    batteries: [
      { id:'b1', model:'Hubble AM-2 200Ah', usable:5,  kw:5,  price:22000 },
      { id:'b2', model:'Hubble AM-5 200Ah', usable:10, kw:5,  price:38000 },
      { id:'b3', model:'Pylontech US5000', usable:4.8, kw:3.5, price:19500 },
      { id:'b4', model:'Freedom Won Lite 10/8', usable:8, kw:5, price:33000 },
      { id:'b5', model:'Alpha ESS SMILE5', usable:10, kw:5,  price:40000 },
    ],
    locations: [
      { id:'l1', city:'Johannesburg', name:'Johannesburg – Sandton', gti:5.20 },
      { id:'l2', city:'Pretoria',     name:'Pretoria – Centurion',   gti:5.35 },
      { id:'l3', city:'Cape Town',    name:'Cape Town – Bellville',  gti:5.80 },
      { id:'l4', city:'Durban',       name:'Durban – Umhlanga',      gti:5.10 },
      { id:'l5', city:'Port Elizabeth',name:'Port Elizabeth – Central',gti:5.40 },
    ],
    loadProfiles: [
      { id:'lp1', name:'Small Home (2–3 bed)',   peak:3.5, daily:20 },
      { id:'lp2', name:'Medium Home (3–4 bed)',  peak:5.0, daily:35 },
      { id:'lp3', name:'Large Home (4–5 bed)',   peak:8.0, daily:55 },
      { id:'lp4', name:'Small Office',           peak:10, daily:70 },
      { id:'lp5', name:'Medium Office / Retail', peak:20, daily:130 },
    ],
    hwSource: { cP:0, cI:0, cB:0, isNova:false }
  };

})();
