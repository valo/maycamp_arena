class CreateExternalContests < ActiveRecord::Migration
  def self.up
    create_table :external_contests, :options => "DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci" do |t|
      t.string :name
      t.datetime :date
      t.timestamps
    end
  end

  def self.down
    drop_table :external_contests
  end
end
