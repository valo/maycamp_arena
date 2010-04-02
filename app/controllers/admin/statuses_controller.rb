class Admin::StatusesController < Admin::BaseController
  def show
    @last_runs = Run.all(:limit => 50, :select => (Run.column_names - ["log", "source_code"]))
  end
end