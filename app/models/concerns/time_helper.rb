module TimeHelper
  extend ActiveSupport::Concern

  module TimeMethods
    def today
      @_time ||= Date.today
    end
  
    def current_year
      @_year ||= today.year
    end
  
    def current_month
      @_month ||= today.month
    end
  
    def current_day
      @_day ||= today.day
    end
  
    def last_month
      @_last_month ||= today.prev_month.month
    end
  
    def year_of_last_month
      @_year_of_last_month ||= today.prev_month.year
    end
  
    def next_month
      @_next_month ||= today.next_month.month
    end
  
    def year_of_next_month
      @_year_of_next_month ||= today.next_month.year
    end
  end

  class_methods do
    include TimeMethods
  end

  included do
    include TimeMethods
  end
end
