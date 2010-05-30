class ContestResult < ActiveRecord::Base
  belongs_to :contest
  belongs_to :user
  has_one :rating_change
  
  validates_uniqueness_of :contest_id, :scope => :user_id
  validates_uniqueness_of :user_id, :scope => :contest_id
end
