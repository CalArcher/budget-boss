class Category < ApplicationRecord

  def add_expense(amount)
    update!(spent: spent + amount)
  end

end
