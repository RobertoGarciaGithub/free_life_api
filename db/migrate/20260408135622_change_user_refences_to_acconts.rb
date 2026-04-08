class ChangeUserRefencesToAcconts < ActiveRecord::Migration[8.1]
  def up
    add_reference :accounts, :accountable, polymorphic: true, type: :uuid, null: true

    execute <<~SQL.squish
      UPDATE accounts SET accountable_type = 'User', accountable_id = user_id
    SQL

    change_column_null :accounts, :accountable_type, false
    change_column_null :accounts, :accountable_id, false

    remove_reference :accounts, :user, foreign_key: true, type: :uuid
  end

  def down
    add_reference :accounts, :user, type: :uuid, null: true, foreign_key: true

    execute <<~SQL.squish
      UPDATE accounts SET user_id = accountable_id WHERE accountable_type = 'User'
    SQL

    change_column_null :accounts, :user_id, false

    remove_reference :accounts, :accountable, polymorphic: true, type: :uuid
  end
end
