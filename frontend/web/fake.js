
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

function addRippleEffect(e) {
  e.addEventListener('click', function (e) {
    const rect = this.getBoundingClientRect();
    const ripple = document.createElement('span');
    ripple.className = 'ripple';
    ripple.style.width = ripple.style.height = Math.max(rect.width, rect.height) + 'px';
    ripple.style.left = e.clientX - rect.left - (ripple.offsetWidth / 2) + 'px';
    ripple.style.top = e.clientY - rect.top - (ripple.offsetHeight / 2) + 'px';
    this.appendChild(ripple);
    setTimeout(() => {
      ripple.remove();
    }, 600); // 600ms - transition-duration in CSS
  });
}

/// Create fake article element
function createFakeArticle() {
  // Создаем элемент article
  const article = document.createElement('article');
  article.className = 'no-padding border ripple-effect no-select'; // white-text left-shadow
  //article.style = '';

  // Добавляем внутреннее содержимое
  article.innerHTML = `
  <div class="grid no-space">
    <div class="m3 l3 m l">
      <img class="responsive" src="images/dash.png"/>
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
  </div>`;

  addRippleEffect(article);
  return article;
}