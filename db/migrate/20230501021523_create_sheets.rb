class CreateSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :sheets do |t|
      t.integer :month, null: false
      t.integer :year, null: false
      t.integer :income, null: false
      t.integer :bill_totals, null: false
      t.integer :total_spent, null: true
      t.integer :together_budger, null: true
      t.integer :user_1_budget, null: true
      t.integer :user_1_spent, null: true
      t.integer :user_2_budget, null: true
      t.integer :user_2_spent, null: true

      t.timestamps
    end
  end
end
