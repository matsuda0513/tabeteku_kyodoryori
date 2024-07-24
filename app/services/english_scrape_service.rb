require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

class EnglishScrapeService
  BASE_URL = 'https://www.maff.go.jp/e/policies/market/k_ryouri/search_menu/syllabary/index.html'  # 英語版のスクレイピング対象URL
  DETAIL_BASE_URL = 'https://www.maff.go.jp/e/policies/market/k_ryouri/search_menu/'

  def self.fetch_all_english_kyodoryouri_links
    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')

    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get(BASE_URL)
    sleep 5

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    search_menu_top = doc.at('.inner')
    links = search_menu_top ? search_menu_top.css('.menu_details .tit06 a').map { |link| { name: link.text.strip, url: DETAIL_BASE_URL + link['href'] } } : []
    links
  end

  def self.fetch_english_kyodoryouri_details(url)
    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')  # ヘッドレスモードで実行するオプションを追加

    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get(url)
    sleep 3

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    name = doc.at('.menu_details .tit06 span.name').text.strip
    prefecture = doc.at('.menu_details .tit06 .pref').text.strip
    history = doc.at('ul.menu_details li h3:contains("History/origin/related events") + p').text.strip
    image_element = doc.at('.menu_main .resp_img')
    image_url = URI.join(url, image_element['src']).to_s
    image_elements = doc.css('.thumb02 .js_modal01 img.resp_img')
    first_image_src = image_elements.first['src'] if image_elements.any?
    image_source = nil

    image_elements.each do |element|
      if element['src'] == first_image_src
        image_source_element = element.parent.next_element.css('.print_none').text.strip
        image_source = image_source_element if image_source_element
        break
      end
    end

    {
      name: name,
      prefecture: prefecture,
      history: history,
      image_url: image_url,
      image_source: image_source,
      detail_url: url
    }
  end

  def self.fetch_and_save_all_english_kyodoryouri
    links = fetch_all_english_kyodoryouri_links
    links.each do |link|
      details = fetch_english_kyodoryouri_details(link[:url])
      food = EnglishFood.find_or_initialize_by(detail_url: details[:detail_url])
      food.update!(
        name: details[:name],
        prefecture: details[:prefecture],
        history: details[:history],
        image_url: details[:image_url],
        image_credit: details[:image_source],
        detail_url: details[:detail_url]
      )
    end
  end
end