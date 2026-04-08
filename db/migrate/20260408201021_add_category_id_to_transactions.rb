class AddCategoryIdToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :category, foreign_key: true, type: :uuid
  end
end
