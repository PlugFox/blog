
/* Add fake articles */

// On DOM ready
window.addEventListener('DOMContentLoaded', (event) => {
  const articlesContainer = document.getElementById('articles');
  const fragment = document.createDocumentFragment();

  for (let i = 0; i < 100; i++) {
    const articleElement = createFakeArticle();
    fragment.appendChild(articleElement);
  }

  articlesContainer.appendChild(fragment);
});

function rippleEffect(e) {
  const inkWell = e.querySelector('ink-well');
  inkWell.addEventListener('click', function (event) {
    const rect = inkWell.getBoundingClientRect();
    const ripple = document.createElement('span');
    inkWell.appendChild(ripple);
    ripple.className = 'ink';

    // Вычисление размера волны
    ripple.style.width = ripple.style.height = Math.max(rect.width, rect.height) + 'px';

    // Вычисление позиции волны относительно элемента
    // Координаты клика относительно окна браузера минус координаты элемента относительно окна браузера
    ripple.style.left = event.clientX - rect.left - (ripple.offsetWidth / 2) + 'px';
    ripple.style.top = event.clientY - rect.top - (ripple.offsetHeight / 2) + 'px';


    // Удаление волны после анимации
    setTimeout(() => {
      ripple.remove();
    }, 600); // 600ms - продолжительность анимации
  });
  return e;
}

/// Create fake article element
function createFakeArticle() {
  // Создаем элемент article
  const article = document.createElement('article');
  article.className = 'article no-padding no-select elevation'; // white-text left-shadow
  //article.style = '';

  // Добавляем внутреннее содержимое
  article.innerHTML = `
  <ink-well>
    <div class="article-layout grid no-space">
      <div class="m3 l3 m l">
        <div class="article-thumbnail responsive">
          <img draggable="false" src="images/dash.png"/>
        </div>
        <!--
        <div class="absolute top left right padding top-shadow white-text">
          <h5>Title</h5>
          <p>Some text here</p>
        </div>
        -->
      </div>
      <div class="s12 m9 l9">
        <div class="padding">
          <h5 class="article-title">Article title</h5>
          <div class="divider small-margin"></div>
          <nav class="article-meta">
            <span class="article-meta-item article-meta-date">
              <time datetime="2023-08-15">
                  Aug 15, 2023
              </time>
            </span>
            <span class="article-meta-item article-meta-read-time">1 MIN READ</span>
            <span class="article-meta-item article-meta-tags">
              <a class="article-tag article-tag-broadcast" title="Broadcast">
                  Broadcast
              </a>
              <a class="article-tag article-tag-dart" title="Dart">
                  Dart
              </a>
              <a class="article-tag article-tag-flutter" title="Flutter">
                  Flutter
              </a>
              <a class="article-tag article-tag-russian" title="Russian">
                  Russian
              </a>
            </span>
          </nav>
          <div class="divider small-margin"></div>
          <p class="article-excerpt">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </p>
          <!--
          <nav class="scroll">
            <a class="chip fill medium-elevate medium">Flutter</a>
            <a class="chip fill medium-elevate medium">Flutter</a>
            <a class="chip fill medium-elevate medium">Flutter</a>
            <a class="chip fill medium-elevate medium">Flutter</a>
            <a class="chip fill medium-elevate medium">Flutter</a>
          </nav>
          -->
        </div>
      </div>
    </div>
  </ink-well>`;


  return rippleEffect(article);;
}