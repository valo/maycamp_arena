require 'test_helper'

class A
  include Latinize
  attr_accessor :name
  
  latinize :name
end

class LatinizeTest < ActiveSupport::TestCase
  test "converting bulgarian to latin string" do
    a = A.new
    [
      ["Това е тест, на превръщане на стринг от български на латински", "Tova e test, na prevrashtane na string ot balgarski na latinski"],
      ["Ч", "Ch"],
      ["Асансьор", "Asansior"],
      ["Шишетата", "Shishetata"],
      ["Щъркел", "Shtarkel"]
    ].each do |bg, lat|
      a.name = bg
      assert_equal lat, a.latin_name
    end
  end
end
