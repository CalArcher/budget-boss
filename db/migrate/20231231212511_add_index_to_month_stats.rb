class AddIndexToMonthStats < ActiveRecord::Migration[7.0]
  def change
    add_index :month_stats, [:year, :month]
  end
end
