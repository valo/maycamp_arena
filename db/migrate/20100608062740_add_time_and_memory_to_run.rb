class AddTimeAndMemoryToRun < ActiveRecord::Migration
  def self.up
    add_column :runs, :max_time, :float
    add_column :runs, :max_memory, :integer
    
    Run.reset_column_information
    
    Run.transaction do
      Run.find_each(:batch_size => 20) do |r|
        max_time = r.log.scan(/Used time: ([0-9\.]+)/).map { |t| BigDecimal.new(t.first) }.max
        max_memory = r.log.scan(/Used mem: ([0-9]+)/).map(&:first).map(&:to_i).max
      
        r.update_attribute(:max_time, max_time)
        r.update_attribute(:max_memory, max_memory)
      end
    end
  end

  def self.down
    remove_column :runs, :max_memory
    remove_column :runs, :max_time
  end
end
