class AddPercentFromSavingsToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :percent_from_savings, :decimal, precision: 5, scale: 2
  end
end
