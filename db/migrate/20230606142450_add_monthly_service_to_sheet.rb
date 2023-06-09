class AddMonthlyServiceToSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :sheets, :monthly_service, :integer
  end
end
