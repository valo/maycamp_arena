class ProblemsController < ApplicationController
  def index
    @problems = Problem.includes(:contest)
                       .where(contests: { visible: true, practicable: true })
                       .paginate(page: params[:page], per_page: 50)
  end
end
