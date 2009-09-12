class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table "runs", :force => true do |t|
      t.references  :problem,     :null => false
      t.references  :user,        :null => false
      t.string      :language,    :null => false
      t.text        :source_code, :null => false
      t.string      :status,      :null => false, :default => 'pending'
      t.text        :log
      t.timestamps
    end
  end

  def self.down
    drop_table :runs
  end
end
