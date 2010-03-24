class MergeUsersWithSameEmail < ActiveRecord::Migration
  def self.up
    User.transaction do
      User.all(:select => "DISTINCT email").map(&:email).each do |email|
        say "Processing email #{email}"
        users = User.all(:conditions => { :email => email })

        next if users.length == 1
        
        say "Found duplicate record: #{users.length}"

        # Select the user with the latest run
        main_user = users.sort_by { |user| user.runs.first.andand.created_at || 10.years.ago }.last
        
        say "Choosing the main user to be: #{main_user.inspect}"

        (users - [main_user]).each do |other_user|
          other_user.contest_start_events.each do |event|
            if !ContestStartEvent.first(:conditions => { :user_id => main_user.id, :contest_id => event.contest.id})
              event.update_attribute(:user_id, main_user.id)
              main_user.reload
            else
              say "Duplicate contest event found for user #{other_user.id}. Deleting event #{event.inspect}"
              event.destroy
            end
          end

          other_user.runs.each do |run|
            run.update_attribute(:user_id, main_user.id)
          end
          
          other_user.reload

          other_user.destroy
        end
      end
    end
  end

  def self.down
  end
end
