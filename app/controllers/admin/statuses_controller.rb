class Admin::StatusesController < Admin::BaseController
  def show
    @last_runs = Run.all(:limit => 50)
  end
end