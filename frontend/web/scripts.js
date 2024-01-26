// On DOM ready
window.addEventListener('DOMContentLoaded', (event) => {
  // Drawer and overlay toggle
  const overlay = document.querySelector('#drawer-main > .overlay');
  const dialog = document.querySelector('#drawer-main > dialog');
  document.body.addEventListener('click', function (e) {
    if (e.target && e.target.matches('.drawer-toggle')) {
      if (dialog.classList.contains('active')) {
        overlay.classList.remove('active');
        dialog.classList.remove('active');
        dialog.blur();
      } else {
        overlay.classList.add('active');
        dialog.classList.add('active');
        dialog.focus();
      }
    }
  });
});

// Sliver App Bar
/* document.addEventListener('DOMContentLoaded', () => {
  let lastScrollTop = 0;
  const appbar = document.getElementById('appbar');

  window.addEventListener('scroll', () => {
    let currentScroll = window.pageYOffset || document.documentElement.scrollTop;

    if (currentScroll > lastScrollTop) {
      // Скролл вниз
      appbar.classList.add('appbar-hidden');
      document.body.style.backgroundColor = 'rgba(0, 0, 0, 0.2)';
    } else {
      // Скролл вверх
      appbar.classList.remove('appbar-hidden');
      document.body.style.backgroundColor = 'rgba(255, 0, 0, 0.2)';
    }
    lastScrollTop = currentScroll <= 0 ? 0 : currentScroll; // Для браузеров, которые не поддерживают отрицательный скролл
  }, false);
}); */

function setPage(path, title) {
  if (path === undefined || path === null || path === window.location.hash) {
    return;
  }
  const overlay = document.querySelector('#drawer-main > .overlay');
  const dialog = document.querySelector('#drawer-main > dialog');
  overlay.classList.remove('active');
  dialog.classList.remove('active');
  dialog.blur();

  window.location.hash = path;
  document.title = title;
  window.history.replaceState(null, title, '#' + path);
}