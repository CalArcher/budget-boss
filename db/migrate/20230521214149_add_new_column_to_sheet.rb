class AddNewColumnToSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :sheets, :payday_count, :integer
  end
end
