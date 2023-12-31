class AddIndexToSheets < ActiveRecord::Migration[7.0]
  def change
    add_index :sheets, [:year, :month]
  end
end
