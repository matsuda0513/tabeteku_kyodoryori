class FoodsController < ApplicationController
  def index
    @foods = ScrapeService.fetch_all_kyodoryouri_links
  end

  def show
    @food = Food.find(params[:id])
    @kyodoryouri_info = {
      name: @food.name,
      prefecture: @food.prefecture,
      history: @food.history,
      image_url: @food.image_url,
      image_source: @food.image_credit
    }
  end

  def search
    @foods = Food.search(params[:keyword])
  end
end