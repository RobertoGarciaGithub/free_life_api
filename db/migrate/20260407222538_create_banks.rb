class CreateBanks < ActiveRecord::Migration[8.1]
  def change
    create_table :banks, id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
