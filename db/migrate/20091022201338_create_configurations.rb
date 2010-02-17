class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations, :force => true do |t|
      t.string :key, :null => false
      t.string :value
      t.string :value_type, :default => "string", :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
