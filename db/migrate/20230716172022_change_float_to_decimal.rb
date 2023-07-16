class ChangeFloatToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :sheets, :income, :decimal, precision: 9, scale: 2
    change_column :sheets, :bill_totals, :decimal, precision: 9, scale: 2
    change_column :sheets, :user_2_spent, :decimal, precision: 9, scale: 2
    change_column :sheets, :user_1_spent, :decimal, precision: 9, scale: 2
    change_column :sheets, :user_2_budget, :decimal, precision: 9, scale: 2
    change_column :sheets, :user_1_budget, :decimal, precision: 9, scale: 2
    change_column :sheets, :user_3_spent, :decimal, precision: 9, scale: 2
    change_column :sheets, :user_3_budget, :decimal, precision: 9, scale: 2
    change_column :sheets, :saved, :decimal, precision: 9, scale: 2
    change_column :sheets, :payday_sum, :decimal, precision: 9, scale: 2

    change_column :transactions, :tx_amount, :decimal, precision: 9, scale: 2

    change_column :bills, :bill_amount, :decimal, precision: 9, scale: 2

  end
end
