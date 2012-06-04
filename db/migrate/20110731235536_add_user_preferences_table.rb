# -*- encoding : UTF-8 -*-
class AddUserPreferencesTable < ActiveRecord::Migration
  def self.up
    create_table :user_preferences, :force => true do |t|
      t.references :user
      t.binary :preferences
      t.timestamps
    end
  end

  def self.down
    drop_table :user_preferences
  end
end
