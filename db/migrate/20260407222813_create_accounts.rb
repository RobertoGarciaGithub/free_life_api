class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.money :amount, null: false, default: 0
      t.integer :profitability, null: false

      t.references :bank, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
