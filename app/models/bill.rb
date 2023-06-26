class Bill < ApplicationRecord

  def self.bill_totals
    Bill.pluck(:bill_amount).sum.to_f
  end

  def self.bill_names
    Bill.pluck(:bill_name)
  end

end
