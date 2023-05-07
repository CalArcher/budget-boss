class UpdateTypeTransactionsTable < ActiveRecord::Migration[7.0]
  def change
    change_column: :transactions, :tx_type, :integer, null: false
    change_column: :transactions, :tx_amount, :integer, null: false
    add_column: :transactions, :tx_currenct, :integer, null: false
  end
end
