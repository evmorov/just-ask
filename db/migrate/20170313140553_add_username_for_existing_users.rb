class AddUsernameForExistingUsers < ActiveRecord::Migration[5.0]
  def change
    User.find_each do |user|
      user.update(username: user.email.split('@').first) unless user.username
    end
  end
end
