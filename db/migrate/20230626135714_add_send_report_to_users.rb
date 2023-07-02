class AddSendReportToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :send_report, :integer
  end
end
