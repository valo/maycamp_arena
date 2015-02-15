class GenerateContestResults
  def initialize(contest)
    @contest = contest
  end

  def call
    results = []
    contest_start_events.includes(:user).find_each do |event|
      runs_count = event.user.runs.during_contest.count
      next if (not event.user.participates_in_contests?) || runs_count == 0

      results << [event.user] + points_for_user(event.user) + [total_points_for_user(event.user)]
    end

    results.sort! { |a,b| b[-1] <=> a[-1] }

    # Compute the unique scores and the number people with each score
    diff_scores = results.map { |r| r[-1] }.uniq.map { |score| [score, results.select { |res| res[-1] == score }.length] }
    results.each do |row|
      row.unshift diff_scores.map { |score, number| score > row[-1] ? number : 0 }.sum + 1
    end
  end

  private

  attr_reader :contest

  def contest_start_events
    contest.contest_start_events
  end

  def problems
    contest.problems
  end

  def final_run_for_problem_and_user_id(runs, user_id)
    return runs.during_contest.where(:runs => { :user_id => user_id }).max_by(&:total_points) if contest.best_submit_results

    runs.during_contest.where(:runs => { :user_id => user_id }).order("runs.created_at DESC").first
  end

  def points_for_user(user)
    problems.map do |problem|
      final_run = final_run_for_problem_and_user_id(problem.runs, user.id)

      if final_run
        final_run.points + [final_run.total_points]
      else
        ["0"] * problem.number_of_tests + ["0"]
      end
    end
  end

  def total_points_for_user(user)
    problems.map do |problem|
      final_run = final_run_for_problem_and_user_id(problem.runs, user.id)

      final_run ? final_run.total_points_float : 0
    end.sum
  end
end
