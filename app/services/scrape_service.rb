require 'selenium-webdriver'

# require 'nokogiri'
# require 'open-uri'

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
    sleep 4  # ページが完全に読み込まれるまで待つ

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
    sleep 4

    doc = Nokogiri::HTML(driver.page_source)
    driver.quit

    name = doc.at('.menu_details .name').text.strip
    prefecture = doc.at('.menu_details .pref').text.strip
    history = doc.at('ul.menu_details li h3:contains("歴史・由来・関連行事") + p').text.strip
    image_element = doc.at('.menu_main img')
    image_url = URI.join(url, image_element['src']).to_s
    # 修正されたimage_sourceの取得ロジック
    # 最初の画像提供元を取得する
    image_source = nil
    doc.css('.thumb02 .js_modal01').each do |element|
      image_source_element = element.at('.dl_copy.mt10')
      if image_source_element
        image_source = image_source_element.text.strip
        break
      end
    end
    # image_source_element = doc.at('.dl_copy.mt10') # 正しいセレクタを使用
    # image_source = image_source_element.text.strip if image_source_element
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
    # 修正されたimage_sourceの取得ロジック
    image_source_element = doc.at('.dl_copy.mt10') # 正しいセレクタを使用
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

  def self.fetch_and_save_all_kyodoryouri
    links = fetch_all_kyodoryouri_links
    links.each do |link|
      details = fetch_kyodoryouri_details(link[:url])
      food = Food.find_or_initialize_by(detail_url: details[:detail_url])
      if food.new_record?
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
