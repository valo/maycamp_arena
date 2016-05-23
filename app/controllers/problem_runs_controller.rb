class ProblemRunsController < ApplicationController
  def show
    @runs = Run.includes(:user)
               .where.not(users: { role: User::ADMIN })
               .where(problem: problem.id)
               .order('runs.created_at DESC')
               .paginate(per_page: 50, page: params.fetch(:page, 1))
  end

  private

  attr_reader :problem

  def problem
    @problem ||= Problem.joins(:contest).where(contests: { visible: true, practicable: true }).find(params[:id])
  end
end
