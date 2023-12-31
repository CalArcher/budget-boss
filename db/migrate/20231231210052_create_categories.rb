class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.numeric :budget
      t.numeric :spent
      t.timestamps
    end

    create_table :month_stats do |t|
      t.integer :month
      t.integer :year
      t.numeric :total_spent
      t.numeric :total_saved
      t.numeric :remaining_budget
      t.timestamps
    end
  end
end
