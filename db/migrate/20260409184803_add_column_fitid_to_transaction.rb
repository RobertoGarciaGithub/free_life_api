class AddColumnFitidToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :fitid, :string
    add_index :transactions, :fitid, unique: true
  end
end
