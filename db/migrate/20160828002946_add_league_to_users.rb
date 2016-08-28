class AddLeagueToUsers < ActiveRecord::Migration
  def change
    add_column :users, :league, :string
    add_column :users, :round, :integer
  end
end
