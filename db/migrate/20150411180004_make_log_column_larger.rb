class MakeLogColumnLarger < ActiveRecord::Migration
  def up
    change_column :run_blob_collections, :log, :binary, limit: 1.megabyte
  end

  def down
    change_column :run_blob_collections, :log, :text
  end
end
