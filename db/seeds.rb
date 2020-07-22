# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
User
  .create_with(
    name: "The admin",
    email: "valentin.mihov@gmail.com",
    unencrypted_password: "123123",
    unencrypted_password_confirmation: "123123",
    role: User::ADMIN,
    city: "Sofia")
  .find_or_create_by!(
    login: 'root'
  )

group = Group.find_or_create_by!(name: "Група Е")

contest = Contest.create_with(
  duration: 300,
  group: group,
  start_time: 1.year.ago,
  end_time: 1.year.ago,
  runner_type: "fork"
).find_or_create_by!(name: "Пролетен турнир 2020")

problem1 = Problem.create_with(
  contest: contest,
  time_limit: 1,
  memory_limit: 128.megabytes
).find_or_create_by!(name: "Задача 1")

problem2 = Problem.create_with(
  contest: contest,
  time_limit: 1,
  memory_limit: 128.megabytes
).find_or_create_by!(name: "Задача 2")