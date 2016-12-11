class AddUserStuff < ActiveRecord::Migration[5.0]
  def change
      add_column :users, :session_token, :string
      add_column :users, :twitter_id, :integer
  end
end
