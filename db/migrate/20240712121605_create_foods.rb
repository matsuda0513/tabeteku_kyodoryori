class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.text :description
      t.string :prefecture
      t.timestamps
    end
    add_index :foods, :name, unique: true
  end
end
