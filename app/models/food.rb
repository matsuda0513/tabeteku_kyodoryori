class Food < ApplicationRecord
  validates :name, presence: true
  validates :prefecture, presence: true
  validates :history, presence: true
  validates :image_url, presence: true
  validates :detail_url, presence: true, uniqueness: true

  def self.search(search)
    if search != ""
      Food.where('text LIKE(?)', "%#{search}%")
    else
      Food.all
    end
  end
end
