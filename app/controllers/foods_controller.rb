class FoodsController < ApplicationController
  def index
    prefecture_order = [
      "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", 
      "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
      "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", 
      "岐阜県", "静岡県", "愛知県", "三重県",
      "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
      "鳥取県", "島根県", "岡山県", "広島県", "山口県",
      "徳島県", "香川県", "愛媛県", "高知県",
      "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]

    foods_grouped_by_prefecture = Food.all.group_by(&:prefecture)
    @foods_by_prefecture = prefecture_order.each_with_object({}) do |prefecture, hash|
      hash[prefecture] = foods_grouped_by_prefecture[prefecture] || []
    end
  end

  def show
    @food = Food.find(params[:id])
    extracted_name = @food.name.split(/[／(（]/).first
    encoded_name = URI.encode_www_form_component(extracted_name)
    encoded_prefecture = URI.encode_www_form_component(@food.prefecture)

    @kyodoryouri_info = {
      name: @food.name,
      prefecture: @food.prefecture,
      history: @food.history,
      image_url: @food.image_url,
      image_source: @food.image_credit
    }
      @tabelog_url = "https://tabelog.com/rstLst/?vs=1&sa=&sk=#{encoded_name}&sw=#{encoded_name}&trailing_slash=true&srchTg=2"
      # https://tabelog.com/rst/rstsearch/?LstKind=1&voluntary_search=1&lid=top_navi1&sk=#{encoded_name}&sa_input=#{encoded_prefecture}
      @instagram_url = "https://www.instagram.com/explore/tags/#{encoded_name}"
      @cookpad_url = "https://cookpad.com/search/#{encoded_name}"
    end

  def search
    @foods = Food.search(params[:name_keyword], params[:prefecture_keyword])
  end
end