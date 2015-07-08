module Admin::RunsHelper
	def have_visible? runs
		runs.each do |run|
			return true if policy(run).show?
		end
		false
	end
end
