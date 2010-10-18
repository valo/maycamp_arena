class AddDiffParamsToProblem < ActiveRecord::Migration
  def self.up
    add_column :problems, :diff_parameters, :string, :default => "", :null => false
  end

  def self.down
    remove_column :problems, :diff_parameters
  end
end
