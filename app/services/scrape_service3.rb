require 'selenium-webdriver'
require 'nokogiri'
# require 'open-uri'

class ScrapeService
  BASE_URL = 'https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/index.html'
  DETAIL_BASE_URL = 'https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/'


  def self.fetch_all_kyodoryouri_links
        # Chromeの設定
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless')  # ヘッドレスモードで実行
    
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