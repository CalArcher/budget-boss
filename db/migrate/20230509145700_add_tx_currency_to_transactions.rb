class AddTxCurrencyToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :tx_currency, :string
  end
end
