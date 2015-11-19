class MapContestGroup < ActiveRecord::Migration
    def change
        get_all_content_groups = ContestGroup.all()

        get_all_content_groups.each do |c|
            Contest.where("name LIKE ?" , "%#{c.name}%").update_all({:contest_group_id => c.id})
        end

        Contest.where("contest_group_id IS NULL").update_all({:contest_group_id => 1})
    end
end
