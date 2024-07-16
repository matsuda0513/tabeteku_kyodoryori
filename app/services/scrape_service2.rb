# require 'nokogiri'
# require 'selenium-webdriver'
# driver = Selenium::WebDriver.for :chrome

  # url = URI.open('https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/index.html')
  # doc = Nokogiri::HTML(url)

  # doc.css('#SearchMenuTop > div:nth-child(1) > p:nth-child(1) > a')

  # require 'csv'

require 'mechanize'
require 'nokogiri'

agent = Mechanize.new
page = agent.get("https://www.maff.go.jp/j/keikaku/syokubunka/k_ryouri/search_menu/index.html")

# ページのHTMLを確認
html = page.body
nokogiri_doc = Nokogiri::HTML(html)

# 正しいセレクタを確認
elements = nokogiri_doc.search('.list a')
puts elements

# URLを抽出
urls = []
elements.each do |ele|
  urls << ele.get_attribute('href')
end

puts urls
