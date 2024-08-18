class AddFoodIdAndFoodNameToEnglishFoods < ActiveRecord::Migration[7.0]
  def change
    add_column :english_foods, :food_id, :integer
    add_column :english_foods, :food_name, :string
  end
end
