class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.string :prefecture, null: false
      t.text :history, null: false
      t.string :image_url, null: false
      t.string :image_credit
      t.string :detail_url, null: false

      t.timestamps
    end

    add_index :foods, :name
    add_index :foods, :prefecture
    add_index :foods, :detail_url, unique: true
  end
end
