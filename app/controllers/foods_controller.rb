class FoodsController < ApplicationController
  def index
    @foods = ScrapeService.fetch_all_kyodoryouri_links
  end

  def show
    url = params[:url]
    @kyodoryouri_info = ScrapeService.fetch_kyodoryouri_details(url)
  end
end