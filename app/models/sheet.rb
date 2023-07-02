class Sheet < ApplicationRecord
  include TimeHelper
  include SmsHelper

  def self.find_or_create_sheet(month, year, set_starting_values = nil)
    SheetCreateService.new(month, year, set_starting_values).find_or_create
  end
end

# Sheet.where(month: 6, year: 2023).update!(
#   income: 6000.0,                                                
#   bill_totals: 2500.0,                                           
#   user_3_budget: 500.0,                                         
#   user_1_budget: 400.0,                                          
#   user_1_spent: 255.0,                                            
#   user_2_budget: 400.0,                                          
#   user_2_spent: 520.0,                                            
#   payday_count: 4,
#   user_3_spent: 444,
#   monthly_service: nil,
# )

# Sheet.find_by(month: 7, year: 2023)&.destroy!