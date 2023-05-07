class CreateUserCommands < ActiveRecord::Migration[7.0]
  def change
    create_table :user_commands do |t|
      t.string :body

      t.timestamps
    end
  end
end
