# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'json'

file_path = Rails.root.join('db', 'seeds', 'foods.json')
if File.exists?(file_path)
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