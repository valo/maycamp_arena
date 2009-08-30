class Problem < ActiveRecord::Base
  has_many :runs
  belongs_to :contest
end
