class Configuration < ActiveRecord::Base
  module Constants
    TESTS_UPDATED_AT = "tests_updated_at".freeze
  end

  include Constants

  validates_inclusion_of :value_type, :in => %w{string int float bool datetime}
  validates_presence_of :key
  validates_uniqueness_of :key, case_sensitive: true

  def to_value
    return nil if self.value.nil?
    case self.value_type
      when "int" then self.value.to_i
      when "float" then self.value.to_f
      when "bool" then self.value == "true" or self.value == "1"
      when "datetime" then self.value.to_time
      else self.value
    end
  end

  class << self
    def set!(key, value)
      conf = self.find_or_create_by(:key => key)
      conf.value = value
      conf.value_type = case value
                    when Integer then "int"
                    when Float then "float"
                    when TrueClass then "bool"
                    when FalseClass then "bool"
                    when Time then "datetime"
                    else "string"
                  end
      conf.save!
    end

    def get(key)
      self.find_by_key(key).andand.to_value
    end
  end
end
