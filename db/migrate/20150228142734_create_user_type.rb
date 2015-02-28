class CreateUserType < ActiveRecord::Migration
  def up
    add_column :users, :role, :string, default: "contester", null: false

    User.where(admin: true).update_all(role: "admin")

    remove_column :users, :admin
    remove_column :users, :contester
  end

  def down
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :contester, :boolean, default: true, null: false

    User.where(role: "admin").update_all(admin: true)

    remove_column :users, :role
  end
end
