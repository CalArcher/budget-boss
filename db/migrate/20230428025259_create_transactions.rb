class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :tx_name
      t.string :tx_type
      t.integer :tx_amount

      t.timestamps
    end
  end
end
