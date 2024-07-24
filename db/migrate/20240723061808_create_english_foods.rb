class CreateEnglishFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :english_foods do |t|
      t.string :name, null: false
      t.string :prefecture, null: false
      t.text :history, null: false
      t.string :image_url, null: false
      t.string :image_credit
      t.string :detail_url, null: false

      t.timestamps
    end
    
      add_index :english_foods, :name
      add_index :english_foods, :prefecture
      add_index :english_foods, :detail_url, unique: true
  end
end
