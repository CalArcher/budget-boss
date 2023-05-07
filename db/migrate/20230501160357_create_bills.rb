class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.string :bill_name, null: false
      t.integer :bill_amount, null: false
      

      t.timestamps
    end
  end
end
