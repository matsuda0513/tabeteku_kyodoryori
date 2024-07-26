export default function initSlider() {
  const slides = document.querySelectorAll('.slider img');
  if (slides.length === 0) return; // スライドがない場合は初期化しない

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

  const nextButton = document.querySelector('.next-button');
  const prevButton = document.querySelector('.prev-button');
  if (nextButton && prevButton) {
    nextButton.addEventListener('click', () => {
      stopAutoSlide();
      nextSlide();
      startAutoSlide();
    });

    prevButton.addEventListener('click', () => {
      stopAutoSlide();
      previousSlide();
      startAutoSlide();
    });
  }

  // document.querySelector('.next-button').addEventListener('click', () => {
  //   stopAutoSlide();
  //   nextSlide();
  //   startAutoSlide();
  // });

  // document.querySelector('.prev-button').addEventListener('click', () => {
  //   stopAutoSlide();
  //   previousSlide();
  //   startAutoSlide();
  // });

  slides[currentSlide].style.display = 'block'; // 初期スライドを表示
  startAutoSlide(); // 自動スライドを開始
}
