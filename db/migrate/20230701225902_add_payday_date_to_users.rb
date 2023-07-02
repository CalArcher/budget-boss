class AddPaydayDateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :payday_date, :integer
  end
end
