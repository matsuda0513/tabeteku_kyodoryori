class PagesController < ApplicationController
  def home
    @prefectures = Prefecture.all
  end
end
