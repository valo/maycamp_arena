class MakeTimelimitDecimal < ActiveRecord::Migration
  def self.up
    change_column :problems, :time_limit, :decimal, :scale => 2, :precision => 5
  end

  def self.down
    change_column :problems, :time_limit, :integer
  end
end
