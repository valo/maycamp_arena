class AddSandboxTypeToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :runner_type, :string, :default => "box"
    
    Contest.reset_column_information
    Contest.find_each do |c|
      c.runner_type = "fork"
      c.save!
    end
  end

  def self.down
    remove_column :contests, :runner_type
  end
end
