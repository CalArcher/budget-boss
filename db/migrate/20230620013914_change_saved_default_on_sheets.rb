class ChangeSavedDefaultOnSheets < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sheets, :saved, from: nil, to: 0
  end
end
