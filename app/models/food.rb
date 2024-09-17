class Food < ApplicationRecord
  validates :name, presence: true
  validates :prefecture, presence: true
  validates :history, presence: true
  validates :image_url, presence: true
  validates :detail_url, presence: true, uniqueness: true

  def self.search(name_keyword, prefecture_keyword)
    foods = Food.all
    if name_keyword.present?
      foods = foods.where('name LIKE ?', "%#{name_keyword}%")
    end
    if prefecture_keyword.present?
      foods = foods.where('prefecture LIKE ?', "%#{prefecture_keyword}%")
    end
    foods
  end

  def image_filename
    # ファイル名を抽出し、拡張子を除く
    filename = File.basename(URI.parse(image_url).path, ".*")
    # ファイル名に"-1"が含まれていた場合は除去
    filename.gsub!('-1', '') if filename.include?('-1')
    filename
  end
end
