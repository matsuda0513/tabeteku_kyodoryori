class EnglishFoodsController < ApplicationController
  def index
    prefecture_order = EnglishPrefecture.all.map(&:name)

    if params[:prefecture].present? && params[:prefecture] != "All"
      selected_prefecture = params[:prefecture]
      @foods = EnglishFood.where(prefecture: selected_prefecture)
      @foods_by_prefecture = { selected_prefecture => @foods }
    else
      @foods = EnglishFood.all
      foods_grouped_by_prefecture = @foods.group_by(&:prefecture)
      @foods_by_prefecture = prefecture_order.each_with_object({}) do |prefecture, hash|
        hash[prefecture] = foods_grouped_by_prefecture[prefecture] || []
      end
    end
  end

  def show
    @food = EnglishFood.find(params[:id])
    extracted_name = @food.food_name.split(/[／(（]/).first
    encoded_name = URI.encode_www_form_component(extracted_name)
    encoded_prefecture = URI.encode_www_form_component(@food.prefecture)

    @kyodoryouri_info = {
      name: @food.name,
      prefecture: @food.prefecture,
      history: @food.history,
      image_url: @food.image_url,
      image_source: @food.image_credit
    }
    base_tabelog_url = "https://tabelog.com/rstLst/?vs=1&sa=&sk=#{encoded_name}&sw=#{encoded_name}&trailing_slash=true&srchTg=2"
    translated_base_url = URI.encode_www_form_component(base_tabelog_url)
    @tabelog_url = "https://translate.google.com/translate?hl=en&sl=ja&u=#{translated_base_url}&prev=search&pto=aue"
    
    @instagram_url = "https://www.instagram.com/explore/tags/#{encoded_name}"

    base_cookpad_url = "https://cookpad.com/search/#{encoded_name}"
    @cookpad_url = "https://translate.google.com/translate?hl=en&sl=ja&u=#{base_cookpad_url}&prev=search&pto=aue"
  end

  def search
    @prefectures = EnglishPrefecture.all
    # 最初に選択された都道府県で絞り込み
    if params[:prefecture].present? && params[:prefecture] != "すべて"
      @foods = EnglishFood.where('LOWER(prefecture) = ?', params[:prefecture].downcase)
    else
      @foods = EnglishFood.all
    end

    # 料理名でさらにフィルタリング
    if params[:name_keyword].present?
      keyword = "%#{params[:name_keyword]}%"
      @foods = @foods.where('LOWER(name) LIKE ?', keyword)
    end

    # 都道府県ごとにグループ化
    @foods_by_prefecture = @prefectures.each_with_object({}) do |prefecture, hash|
      hash[prefecture.name] = @foods.select { |food| food.prefecture == prefecture.name }
    end
  end
end
