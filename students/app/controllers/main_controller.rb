require 'ostruct'

class MainController < ApplicationController
  layout "main", :except => :results
  
  def index
    @contests = Contest.current.select {|contest| contest.visible or current_user.andand.admin?}
    @practice_contests = Contest.practicable.select {|contest| contest.visible or current_user.andand.admin?}
    @top_scores = calc_rankings(false)[0..2]
  end
  
  def results
    @contest = Contest.find(params[:contest_id])
    if !(@contest.results_visible? or current_user.andand.admin?)
      redirect_to root_path
      return
    end
    
    students = @contest.runs.during_contest.map(&:user).uniq
    # Results are in the form:
    # [
    #   [student_name, [task1_test1_pts, task1_test2_pts], [task2_test1_pts, ...]]
    # ]
    @results = students.reject(&:admin?).map do |student|
      total = 0
      [student.name] + @contest.problems.map do |problem|
        last_run = problem.runs.during_contest.select { |r| r.user == student }.first
        
        if last_run
          total += last_run.total_points
          last_run.points + [last_run.total_points]
        else
          ["0"] * problem.number_of_tests + ["0"]
        end
      end + [total]
    end
    
    @results.sort! { |a,b| b[-1] <=> a[-1] }
    
    # Compute the unique scores and the number people with each score
    diff_scores = @results.map(&:last).uniq.map { |score| [score, @results.select { |res| res.last == score }.count] }
    @results.each do |row|
      row.unshift diff_scores.map { |score, number| score > row.last ? number : 0 }.sum + 1
    end
    render :action => :results, :layout => "results"
  end
  
  def rankings
    @rankings = calc_rankings
  end
  
  def download_tests
    Dir.chdir $config[:sets_root] do
      FileUtils.rm "sets.zip" if File.file?("sets.zip")
      Zip::ZipFile.open("sets.zip", Zip::ZipFile::CREATE) do |zipfile|
        Dir.glob("**/*") do |entry|
          zipfile.mkdir(entry) if File.directory?(entry)
          zipfile.add entry, entry if File.file?(entry)
        end
      end
    end

    send_file File.join($config[:sets_root], "sets.zip")
  end

  private
    def calc_rankings(include_zeros = true)
      rankings = {}

      Problem.find_each(:include => :contest, :conditions => ["contests.results_visible = TRUE"]) do |problem|
        Run.maximum(:total_points, :conditions => { :problem_id => problem.id }, :group => :user_id).each do |user_id, score|
          rank = rankings[user_id] ||= OpenStruct.new(:total_points => 0, :full_solutions => 0)
          rank.total_points += score.to_i
          rank.full_solutions += 1 if score == 100
        end
      end
      
      if include_zeros
        User.find_each(:include => :runs, :conditions => ["runs.id IS NULL"], :group => "users.id") do |user|
          rankings[user.id] = OpenStruct.new(:user => user, :total_points => 0, :full_solutions => 0, :total_runs => 0)
        end
      end
      
      rankings = rankings.map do |key, value|
        value.user = User.find(key) unless value.user
        value.total_runs = value.user.runs.count unless value.total_runs
        value
      end
      
      rankings.sort! do |x,y|
        [y.total_points, y.full_solutions, x.total_runs, x.user.name] <=> [x.total_points, x.full_solutions, y.total_runs, y.user.name]
      end
    end
end
