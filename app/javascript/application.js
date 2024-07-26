// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import initSlider from "components/slider"

// 初期化
// Turboのロードイベントにリスンしてスライダーを初期化
document.addEventListener('turbo:load', () => {
  initSlider();
});
