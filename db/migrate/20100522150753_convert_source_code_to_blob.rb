class ConvertSourceCodeToBlob < ActiveRecord::Migration
  def self.up
    change_column :runs, :source_code, :blob
  end

  def self.down
    change_column :runs, :source_code, :text
  end
end
