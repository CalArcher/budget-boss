class AddTxDescriptionToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :tx_description, :string
  end
end