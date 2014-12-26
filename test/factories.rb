# encoding: utf-8

FactoryGirl.define do
  factory :user do |u|
    u.sequence(:email) { |n| "valentin.mihov#{n}@gmail.com" }
    u.sequence(:login) { |n| "login#{n}" }
    u.unencrypted_password "secret"
    u.unencrypted_password_confirmation "secret"
    u.admin false
    u.name "Valentin Mihov"
    u.city { BG_CITIES.first }
  end

  factory :contest do |c|
    c.duration 120
    c.start_time { 1.hour.ago }
    c.end_time { 1.hour.from_now }
    c.name "Test contest"
  end

  factory :run do |r|
    r.language "C/C++"
    r.source_code "#include <stdio.h>"
    r.problem { |problem| problem.association(:problem) }
    r.user { |user| user.association(:problem) }
  end

  factory :problem do |p|
    p.time_limit 1
    p.name "Test problem"
    p.contest { |contest| contest.association(:contest) }
  end

  factory :category do |c|
    c.name "Алчни алгоритми"
  end

  factory :contest_result do |c|
    c.contest { |contest| contest.association(:contest) }
    c.user { |user| user.association(:user) }
  end

  factory :contest_start_event do |c|
    c.contest { |contest| contest.association(:contest) }
    c.user { |user| user.association(:user) }
  end

  factory :external_contest do |c|
    c.name "Some external contest"
    c.date 1.day.ago
  end

  factory :external_contest_result do |r|
    r.external_contest { |c| c.association(:external_contest) }
    r.coder_name "Valentin Mihov"
    r.city "Varna"
    r.points "100"
    r.user_id nil
  end
end
