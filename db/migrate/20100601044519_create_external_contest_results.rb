class CreateExternalContestResults < ActiveRecord::Migration
  def self.up
    create_table :external_contest_results, :options => "DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci" do |t|
      t.references :external_contest
      t.string :coder_name
      t.string :city
      t.references :user
      t.decimal :points
      t.timestamps
    end
  end

  def self.down
    drop_table :external_contest_results
  end
end
