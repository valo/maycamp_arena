class MakeStatusColumnWider < ActiveRecord::Migration
  def change
    change_column :runs, :status, :string, :default => "pending", :limit => 1024
  end
end
