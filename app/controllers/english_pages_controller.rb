class EnglishPagesController < ApplicationController
  def home
    @prefectures = EnglishPrefecture.all
  end
end
