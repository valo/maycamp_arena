class CreateContestResults < ActiveRecord::Migration
  def self.up
    create_table :contest_results, :force => true do |t|
      t.references :contest
      t.references :user
      t.decimal :points, :precision => 10, :scale => 2
      t.timestamps
    end
    
    create_table :rating_changes, :force => true do |t|
      t.references :user
      t.references :contest_result
      t.integer :previous_rating_change_id
      t.decimal :rating, :precision => 10, :scale => 2
      t.decimal :volatility, :precision => 10, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :rating_changes
    drop_table :contest_results
  end
end
