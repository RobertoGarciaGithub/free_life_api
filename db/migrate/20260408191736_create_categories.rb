class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.integer :category_type, null: false
      t.monetize :budget, null: false, default: 0
      t.string :icon, null: false

      t.references :account, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
