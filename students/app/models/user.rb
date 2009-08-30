class User < ActiveRecord::Base
  set_primary_key(:user_id)
  has_many :runs
end
