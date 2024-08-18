# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'json'

file_path = Rails.root.join('db', 'seeds', 'foods.json')
if File.exist?(file_path)
  foods_data = JSON.parse(File.read(file_path))
  foods_data.each do |data|
    Food.find_or_create_by!(detail_url: data['detail_url']) do |food|
      food.name = data['name']
      food.prefecture = data['prefecture']
      food.history = data['history']
      food.image_url = data['image_url']
      food.image_credit = data['image_credit']
    end
  end
end

english_foods_file_path = Rails.root.join('db', 'seeds', 'english_foods.json')
if File.exist?(english_foods_file_path)
  english_foods_data = JSON.parse(File.read(english_foods_file_path))
  english_foods_data.each do |data|
    EnglishFood.find_or_create_by!(detail_url: data['detail_url']) do |english_food|
      english_food.name = data['name']
      english_food.prefecture = data['prefecture']
      english_food.history = data['history']
      english_food.image_url = data['image_url']
      english_food.image_credit = data['image_credit']
      english_food.food_id = data['food_id']
      english_food.food_name = data['food_name']
    end
  end
end
