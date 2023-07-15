class AddColumnToSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :sheets, :user_3_spent, :numeric, precision: 10, scale: 2
    change_column :sheets, :income, :float, precision: 10, scale: 2
    change_column :sheets, :bill_totals, :float, precision: 10, scale: 2
    change_column :sheets, :total_spent, :float, precision: 10, scale: 2
    add_column :sheets, :user_3_budget, :float, precision: 10, scale: 2
    change_column :sheets, :user_1_budget, :float, precision: 10, scale: 2
    change_column :sheets, :user_1_spent, :float, precision: 10, scale: 2
    change_column :sheets, :user_2_budget, :float, precision: 10, scale: 2
    change_column :sheets, :user_2_spent, :float, precision: 10, scale: 2

    change_column :bills, :bill_amount, :float, precision: 10, scale: 2

    change_column :transactions, :tx_amount, :float, precision: 10, scale: 2

    remove_column :transactions, :tx_currency
  end
end
