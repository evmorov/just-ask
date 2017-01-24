class AddIndexesToAuthorization < ActiveRecord::Migration[5.0]
  def change
    add_index :authorizations, [:provider, :uid]
  end
end
