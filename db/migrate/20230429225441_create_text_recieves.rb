class CreateTextRecieves < ActiveRecord::Migration[7.0]
  def change
    create_table :text_recieves do |t|
      t.text :body

      t.timestamps
    end
  end
end
