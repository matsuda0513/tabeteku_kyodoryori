require 'selenium-webdriver'

# require 'nokogiri'
# require 'open-uri'

class ScrapeService
  BASE_URL = 'https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/index.html'
  DETAIL_BASE_URL = 'https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/'

  def self.fetch_all_kyodoryouri_links
    # Chromeの設定
    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')  # ヘッドレスモードで実行、毎回Chromeを呼び出す。作業を確認する際に必要だが、最終的にはコメントアウトを外す

    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get(BASE_URL)
    sleep 5  # ページが完全に読み込まれるまで待つ

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    search_menu_top = doc.at('#SearchMenuTop')
    links = search_menu_top ? search_menu_top.css('.list .tit a').map { |link| { name: link.text.strip, url: DETAIL_BASE_URL + link['href'] } } : []
    links
  end

  def self.fetch_kyodoryouri_details(url)
    options = Selenium::WebDriver::Chrome::Options.new
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.get(url)
    sleep 5

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    name = doc.at('.menu_details .name').text.strip
    prefecture = doc.at('.menu_details .pref').text.strip
    history = doc.at('ul.menu_details li h3:contains("歴史・由来・関連行事") + p').text.strip
    image_element = doc.at('.menu_main img')
    image_url = URI.join(url, image_element['src']).to_s
    # 修正されたimage_sourceの取得ロジック
    image_source_element = doc.at('.dl_copy.mt10') # 正しいセレクタを使用
    image_source = image_source_element.text.strip if image_source_element
#main_content > div.contentWrap.secTypeA > div:nth-child(3) > div > div > div > ul > li > div > div.dl_copy.mt10
#main_content > div.contentWrap.secTypeA > div:nth-child(3) > div > div > div > ul > li:nth-child(1) > div > div.dl_copy.mt10
    {
      name: name,
      prefecture: prefecture,
      history: history,
      image_url: image_url,
      image_source: image_source,
      detail_url: url
    }
  end

  def self.fetch_and_save_all_kyodoryouri
    links = fetch_all_kyodoryouri_links
    links.each do |link|
      details = fetch_kyodoryouri_details(link[:url])
      Food.create!(
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


#   def self.fetch_kyodoryouri_details(url)
#     doc = Nokogiri::HTML(URI.open(url))

#     name = doc.at('.menu_details .name').text.strip
#     prefecture = doc.at('.menu_details .pref').text.strip
#     history = doc.at('ul.menu_details li h3:contains("歴史・由来・関連行事") + p').text.strip
#     image_element = doc.at('.menu_main img')
#     image_url = DETAIL_BASE_URL + image_element['src']
#     image_source = image_element.next_element.text.strip if image_element.next_element&.name == 'div'

#     {
#       name: name,
#       prefecture: prefecture,
#       history: history,
#       image_url: image_url,
#       image_source: image_source
#     }
#   end

#   def self.fetch_and_save_all_kyodoryouri
#     links = fetch_all_kyodoryouri_links
#     links.each do |link|
#       details = fetch_kyodoryouri_details(link[:url])

#       Food.create!(
#         name: details[:name],
#         prefecture: details[:prefecture],
#         history: details[:history],
#         image_url: details[:image_url],
#         image_credit: details[:image_source]
#       )
#     end
#   end
# end
