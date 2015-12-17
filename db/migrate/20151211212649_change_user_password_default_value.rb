class ChangeUserPasswordDefaultValue < ActiveRecord::Migration
  def change
    change_column :users, :password, :string, default: ""
  end
end
