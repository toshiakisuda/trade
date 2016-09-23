require 'yaml'

class Time
  def self.trade_session_at_now?
    time = Time.now
    time.trade_session?
  end

  def trade_session?
    (self.morning_session? or after_session?) and !self.holiday?  ? true : false  
  end

  def morning_session? 
    self >= Time.parse(self.strftime("%Y-%m-%d") + " 09:30") \
      && self <= Time.parse(self.strftime("%Y-%m-%d") + " 11:30")    
  end

  def after_session?
    self >= Time.parse(self.strftime("%Y-%m-%d") + " 12:30") \
      && self <= Time.parse(self.strftime("%Y-%m-%d") + " 15:00")
  end

  def holiday?
    self.weekend? or self.japan_national_holiday? ? true : false
  end

  def weekend?
    self.sunday? or self.saturday? ? true : false
  end

  def japan_national_holiday?
    load_holidays_list = YAML.load(File.open("#{Rails.root}/config/holidays.yml"))
    holidays = load_holidays_list
    date = Date.strptime(self.strftime("%Y-%m-%d"),"%Y-%m-%d")
    holidays.has_key?(date) ? true : false
  end
end

class Date
  def load_holidays_list
    YAML.load(File.open("#{Rails.root}/config/holidays.yml"))
  end

  def japan_national_holiday?
    holidays = load_holidays_list
    holidays.has_key?(self) ? true : false 
  end

  def weekends?
    self.sunday? or saturday? ? true : false
  end

  def holiday?
    weekends? or japan_national_holiday? ? true : false
  end
end
