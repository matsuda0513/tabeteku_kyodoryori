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
    if search_menu_top
      links = search_menu_top.css('.list .tit a').map do |link|
        {
          name: link.text.strip,
          url: DETAIL_BASE_URL + link['href']
        }
      end
    else
      links = []
    end
    links
    end
  end

#   def self.fetch_all_kyodoryouri_links
#     puts "Fetching #{BASE_URL}"
#     doc = Nokogiri::HTML(URI.open(BASE_URL))
#     puts doc.css('#SearchMenuTop')
#     links = doc.css('#SearchMenuTop .list .tit a').map do |link|
#       {
#         name: link.text.strip,
#         url: DETAIL_BASE_URL + link['href']
#       }
#     end
#     links
#   end

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
# 