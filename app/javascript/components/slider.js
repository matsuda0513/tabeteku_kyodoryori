export default function initSlider() {
  const slides = document.querySelectorAll('.slider img');
  let currentSlide = 0;
  let autoSlideInterval;

  function showSlide(index) {
    slides.forEach((slide, i) => {
      slide.style.display = i === index ? 'block' : 'none';
    });
  }

  function nextSlide() {
    currentSlide = (currentSlide + 1) % slides.length;
    showSlide(currentSlide);
  }

  function previousSlide() {
    currentSlide = (currentSlide - 1 + slides.length) % slides.length;
    showSlide(currentSlide);
  }

  function startAutoSlide() {
    autoSlideInterval = setInterval(nextSlide, 3000); // 3秒ごとにスライド
  }

  function stopAutoSlide() {
    clearInterval(autoSlideInterval);
  }

  document.querySelector('.next-button').addEventListener('click', () => {
    stopAutoSlide();
    nextSlide();
    startAutoSlide();
  });

  document.querySelector('.prev-button').addEventListener('click', () => {
    stopAutoSlide();
    previousSlide();
    startAutoSlide();
  });

  slides[currentSlide].style.display = 'block'; // 初期スライドを表示
  startAutoSlide(); // 自動スライドを開始
}
