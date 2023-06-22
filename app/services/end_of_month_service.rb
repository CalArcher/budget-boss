require_relative '../helpers/time_helper'

class EndOfMonthService
  include TimeHelper

  def current_sheet
    Sheet.find_or_create_sheet(month, year)
  end

  def is_new_month?
    day == 1 && current_sheet.monthly_service != 1
  end

  # TODO
  def new_month
    return unless is_new_month?

    # check if last month had 4 paydays => notify if not

    # report remainder / over budget



    current_sheet.update!(

      monthly_service: 1,
    )
    
  end
end