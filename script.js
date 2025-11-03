// MOBILE MENU TOGGLE
document.querySelector('.menu-toggle').addEventListener('click', () => {
  document.querySelector('nav').classList.toggle('open');
});

// TESTIMONIAL ROTATION
const testimonials = document.querySelectorAll('.testimonial');
let i = 0;
setInterval(() => {
  testimonials[i].classList.remove('active');
  i = (i + 1) % testimonials.length;
  testimonials[i].classList.add('active');
}, 4000);

// FADE-IN ON SCROLL
const faders = document.querySelectorAll('.fade-in');
const appearOptions = { threshold: 0.1 };
const appearOnScroll = new IntersectionObserver((entries, observer) => {
  entries.forEach(entry => {
    if (!entry.isIntersecting) return;
    entry.target.classList.add('appear');
    observer.unobserve(entry.target);
  });
}, appearOptions);
faders.forEach(fader => appearOnScroll.observe(fader));

// PAGE TRANSITION ON NAV
document.addEventListener('DOMContentLoaded', () => {
  const links = document.querySelectorAll('a[href]:not([href^="#"])');
  const body = document.body;

  // Activate fade-in on load
  body.classList.add('active');

  links.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
      const href = link.getAttribute('href');
      body.classList.remove('active'); // fade-out
      setTimeout(() => {
        window.location = href;
      }, 600); // match CSS transition
    });
  });
});

// SHRINK LOGO ON SCROLL
window.addEventListener('scroll', () => {
  const header = document.querySelector('header');
  if (window.scrollY > 50) {
    header.classList.add('shrink');
  } else {
    header.classList.remove('shrink');
  }
});

