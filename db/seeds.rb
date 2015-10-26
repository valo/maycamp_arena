# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
u = User.create(
  :login => 'root',
  :name => "The admin",
  :email => "valentin.mihov@gmail.com",
  :unencrypted_password => "123123",
  :unencrypted_password_confirmation => "123123",
  :role => User::ADMIN,
  :city => "Sofia"
)
