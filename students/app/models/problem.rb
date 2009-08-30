class Problem < ActiveRecord::Base
  set_primary_key(:problem_id)
  has_many :runs
  belongs_to :contest
end
