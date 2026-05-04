class AddDeviseFieldsToUsers < ActiveRecord::Migration[8.1]
  def up
    rename_column :users, :password_digest, :encrypted_password
    # Fill any existing NULLs before adding the NOT NULL constraint
    execute "UPDATE users SET encrypted_password = '' WHERE encrypted_password IS NULL"
    change_column_null    :users, :encrypted_password, false
    change_column_default :users, :encrypted_password, ''

    add_column :users, :jti, :string, null: false, default: ''
    add_index  :users, :jti, unique: true
  end

  def down
    remove_index  :users, :jti
    remove_column :users, :jti

    change_column_default :users, :encrypted_password, nil
    change_column_null    :users, :encrypted_password, true
    rename_column :users, :encrypted_password, :password_digest
  end
end
