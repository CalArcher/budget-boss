class AddPaydaySumToSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :sheets, :payday_sum, :float, precision: 10, scale: 2
  end
end
