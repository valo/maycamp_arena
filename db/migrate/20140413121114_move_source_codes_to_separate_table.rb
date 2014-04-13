class MoveSourceCodesToSeparateTable < ActiveRecord::Migration
  def change
    drop_table :run_blob_collections
    create_table :run_blob_collections, :options => "ROW_FORMAT=COMPRESSED KEY_BLOCK_SIZE=8" do |t|
      t.references :run, :null => false
      t.binary :source_code
      t.text :log
    end

    # Make the max_memory column to be BIGINT
    change_table :runs do |t|
      t.change :max_memory, :integer, :limit => 8
    end

    Run.transaction do
      Run.find_each do |r|
        next if r.read_attribute(:source_code).blank?
        r.source_code = r.read_attribute(:source_code)
        r.log = r.read_attribute(:log)
        r.save(validate: false)
      end
    end
  end
end
