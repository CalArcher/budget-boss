class AddDiscordUserIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :discord_userid, :string
  end
end
