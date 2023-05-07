class CreateTextSends < ActiveRecord::Migration[7.0]
  def change
    create_table :text_sends do |t|
      t.text :body

      t.timestamps
    end
  end
end
