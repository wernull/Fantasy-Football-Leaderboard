class AddYahooTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :yahoo_token, :string
  end
end
