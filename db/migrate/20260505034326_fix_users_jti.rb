class FixUsersJti < ActiveRecord::Migration[8.1]
  def up
    # Gera UUID para todos os usuários que têm jti vazio
    User.find_each do |user|
      user.update_column(:jti, SecureRandom.uuid) if user.jti.blank?
    end

    # Muda o default da coluna de "" para nil
    change_column_default :users, :jti, from: '', to: nil
  end

  def down
    change_column_default :users, :jti, from: nil, to: ''
  end
end
