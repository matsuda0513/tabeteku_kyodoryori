class FoodsController < ApplicationController
  def index
    @foods = Food.all
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