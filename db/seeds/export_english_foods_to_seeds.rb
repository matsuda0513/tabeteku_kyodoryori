require 'json'

def export_english_foods_to_seeds
  english_foods = EnglishFood.all
  data = english_foods.map do |english_food|
    {
      name: english_food.name,
      prefecture: english_food.prefecture,
      history: english_food.history,
      image_url: english_food.image_url,
      image_credit: english_food.image_credit,
      detail_url: english_food.detail_url,
      food_id: english_food.food_id,
      food_name: english_food.food_name
    }
  end

  File.open(Rails.root.join('db', 'seeds', 'english_foods.json'), 'w') do |file|
    file.write(JSON.pretty_generate(data))
  end
end

export_english_foods_to_seeds