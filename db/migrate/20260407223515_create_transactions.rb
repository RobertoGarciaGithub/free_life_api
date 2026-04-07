class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.money :amount, null: false, default: 0
      t.string :description, null: false
      t.integer :transactions_type, null: false, default: 0
      t.integer :status, null: false, default: 0

      t.references :transactable, polymorphic: true, type: :uuid, null: false
      t.references :target, polymorphic: true, type: :uuid, null: true
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
