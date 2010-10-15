class CreateExternalContests < ActiveRecord::Migration
  def self.up
    create_table :external_contests do |t|
      t.string :name
      t.datetime :date
      t.timestamps
    end
  end

  def self.down
    drop_table :external_contests
  end
end
