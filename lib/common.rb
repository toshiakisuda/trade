require 'yaml'

class Date
  def load_holidays_list
    YAML.load(File.open("#{Rails.root}/config/holidays.yml"))
  end

  def  japan_holiday?
    holidays = load_holidays_list
    holidays.map { |c| 
      return true if c == self
    }
    return false
  end

  def holiday?

  end
end

