require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'parallel'

class ScrapeService
  BASE_URL = 'https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/index.html'
  DETAIL_BASE_URL = 'https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/'

  def self.fetch_all_kyodoryouri_links
    # Chromeの設定
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')  # ヘッドレスモードで実行するオプションを追加
    options.add_argument('--disable-gpu')  # GPUの使用を無効化するオプションを追加
    options.add_argument('--window-size=1920,1080')  # ウィンドウサイズを設定するオプションを追加

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
    options.add_argument('--headless')  # ヘッドレスモードで実行するオプションを追加
    options.add_argument('--disable-gpu')  # GPUの使用を無効化するオプションを追加
    options.add_argument('--window-size=1920,1080')  # ウィンドウサイズを設定するオプションを追加

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
    image_elements = doc.css('.thumb02 .js_modal01')
    first_image_src = image_elements.first&.at('.dl_img img')&.[]('src')  # &.を使用してnilチェック
    image_source = nil

    if first_image_src
      image_elements.each do |element|
        if element.at('.dl_img img')['src'] == first_image_src
          image_source_element = element.at('.dl_copy.mt10')
          image_source = image_source_element.text.strip if image_source_element
          break
        end
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

  def self.fetch_and_save_all_kyodoryouri
    links = fetch_all_kyodoryouri_links
    Parallel.each(links, in_threads: 2) do |link|
      details = fetch_kyodoryouri_details(link[:url])
      next unless details[:name] && details[:prefecture] && details[:history] && details[:image_url] # 必要なデータがある場合のみ保存
      food = Food.find_or_initialize_by(detail_url: details[:detail_url])
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

  # # 特定のIDを更新するための一時的なメソッド
  # def self.fetch_and_save_kyodoryouri_by_id(id)
  #   food = Food.find(id)
  #   details = fetch_kyodoryouri_details(food.detail_url)
  #   food.update!(
  #     name: details[:name],
  #     prefecture: details[:prefecture],
  #     history: details[:history],
  #     image_url: details[:image_url],
  #     image_credit: details[:image_source],
  #     detail_url: details[:detail_url]
  #   )
  # end
end
