class Time
  def beginning_of_year
    self-(self.yday-1).days-(self.hour).hours-(self.min).minutes-self.sec
  end
  def end_of_year
    self.beginning_of_year + 365.days - 1.second
  end
  def beginning_of_month
    self-(self.mday-1).days-(self.hour).hours-(self.min).minutes-self.sec
  end
  def end_of_month
    self.beginning_of_month + 1.month - 1.second
  end
  def beginning_of_week
    self-(self.wday).days-(self.hour).hours-(self.min).minutes-self.sec
  end
  def end_of_week
    self.beginning_of_week + 1.week - 1.second
  end
  def beginning_of_day
    self-(self.hour).hours-(self.min).minutes-self.sec
  end
  def end_of_day
    self.beginning_of_day + 24.hours - 1.second
  end
  def beginning_of_hour
    self-(self.min).minutes-self.sec
    # Time.at((self.to_i/1.hour).floor*1.hour)
  end
  def end_of_hour
    self.beginning_of_hour + 1.hour - 1.second
    # Time.at((self.to_i/1.hour).floor*1.hour+1.hour)
  end
  def beginning_of_minute
    self-self.sec
    # Time.at((self.to_i/1.minute).floor*1.minute)
  end
  def end_of_minute
    self.beginning_of_minute + 1.minute - 1.second
    # Time.at((self.to_i/1.minute).floor*5.minute)
  end
  
  def beginning_of(secs=1.day)
    case secs
    when 1.hour
      self.beginning_of_hour
    when 1.day
      self.beginning_of_day
    when 1.week
      self.beginning_of_week
    when 1.month
      self.beginning_of_month
    when 1.year
      self.beginning_of_year
    else
      if secs < 1.day
        self.beginning_of_period(secs)
      else
        return self
      end
    end
  end
  
  def end_of(secs=1.day)
    case secs
    when 1.hour
      self.end_of_hour
    when 1.day
      self.end_of_day
    when 1.week
      self.end_of_week
    when 1.month
      self.end_of_month
    when 1.year
      self.end_of_year
    else
      if secs < 1.day
        self.end_of_period(secs)
      else
        return self
      end
    end
  end
  
  def beginning_of_period(secs=5.minutes)
    return self if secs >= 1.day/2
    secs_today = self - self.beginning_of_day
    periods_today = (secs_today/secs).floor
    self.beginning_of_day + periods_today * secs
    # Time.at((self.to_i/seconds).floor*seconds)
  end
  def end_of_period(secs=5.minutes)
    return self if secs >= 1.day/2
    beginning_of(secs) + secs - 1.second
    # Time.at((self.to_i/seconds).floor*seconds+seconds)
  end
  
  def upto(max, interval=1.day, inclusive=true)
    t = self
    while t < max || (inclusive && t <= max)
      yield t
      t += interval
    end
  end
  
protected
  
   def change(options)
     self.class.send(
       self.utc? ? :utc_time : :local_time,
       options[:year]  || self.year,
       options[:month] || self.month,
       options[:day]   || self.day,
       options[:hour]  || self.hour,
       options[:min]   || (options[:hour] ? 0 : self.min),
       options[:sec]   || ((options[:hour] || options[:min]) ? 0 : self.sec),
       options[:usec]  || ((options[:hour] || options[:min] || options[:sec]) ? 0 : self.usec)
     )
  end
  
end
