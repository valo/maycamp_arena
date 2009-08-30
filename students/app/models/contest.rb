class Contest < ActiveRecord::Base
  set_primary_key(:contest_id)
  has_many :problems
end
