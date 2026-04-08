class ChangeColumnMoneyToMonetize < ActiveRecord::Migration[8.1]
  def up
    change_table :accounts do |t|
      t.remove :amount
      t.monetize :amount, null: false, default: 0
    end

    change_table :transactions do |t|
      t.remove :amount
      t.monetize :amount, null: false, default: 0
    end
  end

  def down
    change_table :accounts do |t|
      t.remove_monetize :amount
      t.integer :amount, null: false, default: 0
    end

    change_table :transactions do |t|
      t.remove_monetize :amount
      t.integer :amount, null: false, default: 0
    end
  end
end
