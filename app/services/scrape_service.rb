require 'nokogiri'
require 'open-uri'

class ScrapeService
  BASE_URL = 'https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/index.html'
  DETAIL_BASE_URL = 'https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/'


  def self.fetch_all_kyodoryouri_links
    puts "Fetching #{BASE_URL}"
    doc = Nokogiri::HTML(URI.open(BASE_URL))
    puts doc.css('.more_list thumb01 clm3 mt30')
    links = doc.css('#SearchMenuTop .list .tit a').map do |link|
      {
        name: link.text.strip,
        url: DETAIL_BASE_URL + link['href']
      }
    end
    links
  end

  def self.fetch_kyodoryouri_details(url)
    doc = Nokogiri::HTML(URI.open(url))

    name = doc.at('.menu_details .name').text.strip
    prefecture = doc.at('.menu_details .pref').text.strip
    history = doc.at('ul.menu_details li h3:contains("歴史・由来・関連行事") + p').text.strip
    image_element = doc.at('.menu_main img')
    image_url = DETAIL_BASE_URL + image_element['src']
    image_source = image_element.next_element.text.strip if image_element.next_element&.name == 'div'

    {
      name: name,
      prefecture: prefecture,
      history: history,
      image_url: image_url,
      image_source: image_source
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
        image_credit: details[:image_source]
      )
    end
  end
end
