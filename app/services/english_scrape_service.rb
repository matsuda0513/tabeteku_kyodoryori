require 'selenium-webdriver'

class EnglishScrapeService
  BASE_URL = 'https://www.maff.go.jp/e/policies/market/k_ryouri/search_menu/syllabary/index.html'  # 英語版のスクレイピング対象URL
  DETAIL_BASE_URL = 'https://www.maff.go.jp/e/policies/market/k_ryouri/search_menu/'

  def self.fetch_all_english_food_links
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1920,1080')

    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get(BASE_URL)
    sleep 4

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    search_menu_top = doc.at('.list')
    links = search_menu_top ? search_menu_top.css('.list-group-item a').map { |link| { name: link.text.strip, url: DETAIL_BASE_URL + link['href'] } } : []
    links
  end

  def self.fetch_english_food_details(url)
    options = Selenium::WebDriver::Chrome::Options.new
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get(url)
    sleep 4

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    name = doc.at('.tit06 .name').text.strip
    prefecture = doc.at('.tit06 -prefecture .pref').text.strip
    history = doc.at('ul.menu_details li h3:contains("History & Origin") + p').text.strip
    image_element = doc.at('.menu_main img')
    image_url = URI.join(url, image_element['src']).to_s
    image_source_element = doc.at('.notes mt10')
    image_source = image_source_element.text.strip if image_source_element

    {
      name: name,
      prefecture: prefecture,
      history: history,
      image_url: image_url,
      image_source: image_source,
      detail_url: url
    }
  end

  def self.fetch_and_save_all_english_foods
    links = fetch_all_english_food_links
    links.each do |link|
      details = fetch_english_food_details(link[:url])
      EnglishFood.find_or_create_by(detail_url: details[:detail_url]) do |food|
        food.name = details[:name]
        food.prefecture = details[:prefecture]
        food.history = details[:history]
        food.image_url = details[:image_url]
        food.image_credit = details[:image_source]
      end
    end
  end
end