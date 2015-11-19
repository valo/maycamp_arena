class AddContestGroupIdToContest < ActiveRecord::Migration
  def change
    add_column :contests, :contest_group_id, :integer
  end
end
