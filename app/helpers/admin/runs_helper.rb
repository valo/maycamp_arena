module Admin::RunsHelper
  def have_visible? runs
    runs.any? { |run| policy(run).show? }
  end
end
