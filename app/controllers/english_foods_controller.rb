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
    extracted_name = @food.name.split(/[\/(]/).first
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
    @instagram_url = "https://www.instagram.com/explore/tags/#{encoded_name}"
    @cookpad_url = "https://cookpad.com/search/#{encoded_name}"
  end

  def search
    @foods = EnglishFood.search(params[:name_keyword], params[:prefecture_keyword])
  end
end
