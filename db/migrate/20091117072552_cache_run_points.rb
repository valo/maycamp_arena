class CacheRunPoints < ActiveRecord::Migration
  def self.up
    add_column :runs, :total_points, :decimal, :precision => 10, :scale => 2
    Run.reset_column_information
    
    Run.transaction do
      Run.find_each do |run|
        run.total_points = run.send(:points_float).sum { |test| test.is_a?(BigDecimal) ? test : 0 }.round.to_i
        run.save!
      end
    end
  end

  def self.down
    remove_column :runs, :total_points
  end
end
