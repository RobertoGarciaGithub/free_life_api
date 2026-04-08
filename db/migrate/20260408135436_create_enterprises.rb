class CreateEnterprises < ActiveRecord::Migration[8.1]
  def change
    create_table :enterprises, id: :uuid do |t|
      t.string :legal_name, null: false
      t.string :trade_name
      t.string :cnpj, null: false, index: { unique: true }
      t.references :owner, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.timestamps
    end
  end
end
