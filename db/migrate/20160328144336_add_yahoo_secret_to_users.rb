class AddYahooSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :yahoo_secret, :string
  end
end
