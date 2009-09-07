require 'digest/md5'

class User < ActiveRecord::Base
  set_primary_key(:user_id)
  has_many :runs
  
  validates_uniqueness_of :name
  validates_presence_of :name, :password
  validates_confirmation_of :password
  
  attr_accessor :password
  
  before_save :encrypt_password
  
  private
    def encrypt_password
      self.pass_md5 = Digest::MD5.hexdigest(self.password)
    end
end
