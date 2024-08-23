class FoodsController < ApplicationController
  def index
    prefecture_order = Prefecture.all.map(&:name)

    if params[:prefecture].present? && params[:prefecture] != "すべて"
      selected_prefecture = params[:prefecture]
      @foods = Food.where(prefecture: selected_prefecture)
      @foods_by_prefecture = { selected_prefecture => @foods }
    else
      @foods = Food.all
      foods_grouped_by_prefecture = @foods.group_by(&:prefecture)
      @foods_by_prefecture = prefecture_order.each_with_object({}) do |prefecture, hash|
        hash[prefecture] = foods_grouped_by_prefecture[prefecture] || []
      end
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
    @prefectures = Prefecture.all
    # 最初に選択された都道府県で絞り込み
    if params[:prefecture].present? && params[:prefecture] != "すべて"
      @foods = Food.where(prefecture: params[:prefecture])
    else
      @foods = Food.all
    end

    # 料理名でさらにフィルタリング
    if params[:name_keyword].present?
      keyword = "%#{params[:name_keyword]}%"
      @foods = @foods.where('name LIKE ?', keyword)
    end

    # 都道府県ごとにグループ化
    @foods_by_prefecture = @prefectures.each_with_object({}) do |prefecture, hash|
      hash[prefecture.name] = @foods.select { |food| food.prefecture == prefecture.name }
    end
  end
end
