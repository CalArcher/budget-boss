module TimeHelper
  def time
    @_time ||= Time.now
  end

  def year
    @_year ||= time.year
  end

  def month
    @_month ||= time.month
  end

  def day
    @_day ||= time.day
  end

  def next_month
    @_next_month ||= (month % 12) + 1
  end

  def update_year
    if next_month == 1
      year + 1
    else
      year
    end
  end
end

