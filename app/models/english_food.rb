class EnglishFood < ApplicationRecord
  validates :name, presence: true
  validates :prefecture, presence: true
  validates :history, presence: true
  validates :image_url, presence: true
  validates :detail_url, presence: true, uniqueness: true

  def self.search(name_keyword, prefecture_keyword)
    foods = EnglishFood.all
    if name_keyword.present?
      foods = foods.where('LOWER(name) LIKE ?', "%#{name_keyword.downcase}%")
    end
    if prefecture_keyword.present?
      foods = foods.where('LOWER(prefecture) LIKE ?', "%#{prefecture_keyword.downcase}%")
    end
    foods
  end

  def image_filename
  # 最後の/部分のデータを抽出し、拡張子を除く
  filename = File.basename(URI.parse(image_url).path, ".*")
  filename.gsub!('-1', '') if filename.include?('-1') # "-1" を除去
  filename
  end
end
