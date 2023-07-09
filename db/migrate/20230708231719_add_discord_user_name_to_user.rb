class AddDiscordUserNameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :discord_username, :string
  end
end
