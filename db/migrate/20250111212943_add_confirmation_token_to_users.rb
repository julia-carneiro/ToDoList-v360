class AddConfirmationTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :confirmation_token, :string
  end
end
