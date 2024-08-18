namespace :foods do
  desc "Link English foods with Japanese foods by image filename"
  task link: :environment do
    EnglishFood.find_each do |english_food|
      # 最初に通常の照合を試みる
      matching_food = Food.find_by("image_url LIKE ?", "%/#{english_food.image_filename}.%")
      
      # 通常の照合で見つからない場合、"-1"を除去したファイル名で再照合
      if matching_food.nil?
        matching_food = Food.find_by("image_url LIKE ?", "%/#{english_food.image_filename.gsub('-1', '')}.%")
      end

      if matching_food
        english_food.update(food_id: matching_food.id, food_name: matching_food.name)
        puts "Linked #{english_food.name} with #{matching_food.name}"
      else
        puts "No match found for #{english_food.name}"
      end
    end
  end
end
