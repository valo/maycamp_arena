module Latinize
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    TABLE = {
      "а" => "a", "А" => "A",
      "б" => "b", "Б" => "B",
      "в" => "v", "В" => "V",
      "г" => "g", "Г" => "G",
      "д" => "d", "Д" => "D",
      "е" => "e", "Е" => "E",
      "ж" => "j", "Ж" => "J",
      "з" => "z", "З" => "Z",
      "и" => "i", "И" => "I",
      "й" => "i", "Й" => "I",
      "к" => "k", "К" => "K",
      "л" => "l", "Л" => "L",
      "м" => "m", "М" => "M",
      "н" => "n", "Н" => "N",
      "о" => "o", "О" => "O",
      "п" => "p", "П" => "P",
      "р" => "r", "Р" => "R",
      "с" => "s", "С" => "S",
      "т" => "t", "Т" => "T",
      "у" => "u", "У" => "U",
      "ф" => "f", "Ф" => "F",
      "х" => "h", "Х" => "H",
      "ц" => "c", "Ц" => "C",
      "ч" => "ch", "Ч" => "Ch",
      "ш" => "sh", "Ш" => "Sh",
      "щ" => "sht", "Щ" => "Sht",
      "ъ" => "a", "Ъ" => "A",
      "ь" => "i", "Ь" => "I",
      "ю" => "iu", "Ю" => "Iu",
      "я" => "ia", "Я" => "Ia",
    }
    def latinize(*args)
      args.each do |prop|
        define_method "latin_#{prop}" do
          self.class.latinize_string(self.send(prop))
        end
      end
    end
    
    def latinize_string(string)
      result = StringIO.new("")
      string.each_char do |char|
        result << (TABLE[char] || char)
      end
      
      result.string
    end
  end
end