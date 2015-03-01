class MakeAllAdminsCoaches < ActiveRecord::Migration
  def change
    User.where(role: User::ADMIN).each do |user|
      user.update(role: User::COACH) unless user.login == "root"
    end
  end
end
