class ExternalContestResult < ActiveRecord::Base
  belongs_to :external_contest
  belongs_to :user
  
  has_one :rating_change, :as => :contest_result
  
  default_scope :order => 'points DESC'
  
  alias_attribute :contest, :external_contest
end
