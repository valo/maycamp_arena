class MainController < ApplicationController
  def index
  end
  
  def results
    @contest = Contest.find(params[:contest_id])
    students = @contest.runs.map(&:user).uniq
    # Results are in the form:
    # [
    #   [student_name, [task1_test1_pts, task1_test2_pts], [task2_test1_pts, ...]]
    # ]
    @results = students.map do |student|
      total = 0
      [student.name] + @contest.problems.map do |problem|
        last_run = problem.runs.select { |r| r.user == student }.last
        
        total += last_run.total_points
        last_run.points + [last_run.total_points]
      end + [total]
    end
    
    @results.sort { |a,b| b[-1] <=> a[-1] }
  end
end
