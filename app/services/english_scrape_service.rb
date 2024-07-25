require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'

class EnglishScrapeService
  BASE_URL = 'https://www.maff.go.jp/e/policies/market/k_ryouri/search_menu/syllabary/index.html'  # 英語版のスクレイピング対象URL
  DETAIL_BASE_URL = 'https://www.maff.go.jp/e/policies/market/k_ryouri/search_menu/menu/'

  def self.fetch_all_english_kyodoryouri_links
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')

    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get(BASE_URL)
    sleep 5

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    links = []
    doc.css('ul li.list-group-item a').each do |link|
      href = link['href']
      full_url = URI.join(DETAIL_BASE_URL, href).to_s
      links << { name: link.text.strip, url: full_url }
    end

    links
  end

  def self.fetch_english_kyodoryouri_details(url)
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')  # ヘッドレスモードで実行するオプションを追加

    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get(url)
    sleep 3

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    name = doc.at('.menu_details .tit06 span.name')&.text&.strip || ''
    prefecture = doc.at('.menu_details .tit06 .pref')&.text&.strip || ''
    history = doc.at('ul.menu_details li h3:contains("History/origin/related events") + p')&.text&.strip || ''
    image_element = doc.at('.menu_main .resp_img')
    image_url = URI.join(url, image_element['src']).to_s if image_element

    image_elements = doc.css('.thumb02 .js_modal01 img.resp_img')
    first_image_element = image_elements.first
    image_source = nil

    if first_image_element
      parent_div = first_image_element.parent
      image_source_element = parent_div.next_element.at('p')rescue nil
      image_source = image_source_element&.text&.strip
    end

    {
      name: name,
      prefecture: prefecture,
      history: history,
      image_url: image_url,
      image_source: image_source,
      detail_url: url
    }
  rescue => e
    puts "Error fetching details for URL: #{url}"
    puts e.message
    {
      name: '',
      prefecture: '',
      history: '',
      image_url: '',
      image_source: '',
      detail_url: url
    }
  end

  def self.fetch_and_save_all_english_kyodoryouri
    links = fetch_all_english_kyodoryouri_links
    links.each do |link|
      details = fetch_english_kyodoryouri_details(link[:url])
      food = EnglishFood.find_or_initialize_by(detail_url: details[:detail_url])
      if food.new_record? || food.name != details[:name] || food.prefecture != details[:prefecture] || 
        food.history != details[:history] || food.image_url != details[:image_url] || food.image_credit != details[:image_source]
       
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
end
