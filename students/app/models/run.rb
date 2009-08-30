class Run < ActiveRecord::Base
  set_primary_key :run_id
  belongs_to :user
  belongs_to :problem
end
