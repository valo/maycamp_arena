class ExternalContestResult < ActiveRecord::Base
  belongs_to :external_contest
  belongs_to :user
  
  alias_attribute :contest, :external_contest
end
