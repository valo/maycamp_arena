class CreateContestStartEvent < ActiveRecord::Migration
  def self.up
    create_table :contest_start_events, :force => true do |t|
      t.references :user
      t.references :contest
      t.timestamps
    end
    add_index :contest_start_events, [:user_id, :contest_id], :unique => true
  end

  def self.down
    remove_index :contest_start_events, :column => [:user_id, :contest_id]
    drop_table :contest_start_events
  end
end
