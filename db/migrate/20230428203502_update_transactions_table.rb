class UpdateTransactionsTable < ActiveRecord::Migration[7.0]
  def change
    # Get a list of all tables in the database
    tables = ActiveRecord::Base.connection.tables

    # Iterate over each table and update its columns to be null:false
    tables.each do |table|
      columns = ActiveRecord::Base.connection.columns(table)
      columns.each do |column|
        change_column_null table.to_sym, column.name.to_sym, false
      end
    end
  end
end
