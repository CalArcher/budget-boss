class Sheet < ApplicationRecord
  include TimeHelper
  include SmsHelper

  def self.find_or_create_sheet(month, year, set_starting_values = nil)
    SheetCreateService.new(month, year, set_starting_values).find_or_create
  end
end