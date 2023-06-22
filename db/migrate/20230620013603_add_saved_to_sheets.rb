class AddSavedToSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :sheets, :saved, :float, precision: 10, scale: 2
  end
end
