require 'yaml'

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
