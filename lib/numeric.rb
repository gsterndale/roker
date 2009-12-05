class Numeric
  SECONDS_PER_MINUTE = 60.0
  SECONDS_PER_HOUR = SECONDS_PER_MINUTE * 60
  SECONDS_PER_DAY = SECONDS_PER_HOUR * 24
  SECONDS_PER_WEEK = SECONDS_PER_DAY * 7
  SECONDS_PER_MONTH = SECONDS_PER_DAY * 30
  SECONDS_PER_YEAR = SECONDS_PER_DAY * 365.25
  
  def years
    self * SECONDS_PER_YEAR
  end
  alias_method :year, :years
  
  def months
    self * SECONDS_PER_MONTH
  end
  alias_method :month, :months
  
  def weeks
    self * SECONDS_PER_WEEK
  end
  alias_method :week, :weeks
  
  def days
    self * SECONDS_PER_DAY
  end
  alias_method :day, :days
  
  def hours
    self * SECONDS_PER_HOUR
  end
  alias_method :hour, :hours
  
  def minutes
    self * SECONDS_PER_MINUTE
  end
  alias_method :minute, :minutes
  
  def seconds
    self
  end
  alias_method :second, :seconds
  
end