class FoodsController < ApplicationController
  def index
    @foods = Food.all
  end

  def show
    @food = Food.find(params[:id])
    @kyodoryouri_info = ScrapeService.fetch_kyodoryouri_details(@food.detail_url)
  end
end