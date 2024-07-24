require 'json'

def export_foods_to_seeds
  foods = Food.all
  data = foods.map do |food|
    {
      name: food.name,
      prefecture: food.prefecture,
      history: food.history,
      image_url: food.image_url,
      image_credit: food.image_credit,
      detail_url: food.detail_url
    }
  end

  File.open(Rails.root.join('db', 'seeds', 'foods.json'), 'w') do |file|
    file.write(JSON.pretty_generate(data))
  end
end

export_foods_to_seeds
