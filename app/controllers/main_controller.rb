# -*- encoding : utf-8 -*-
require 'ostruct'

class MainController < ApplicationController
  layout 'main', except: :results
  before_action :check_user_profile
  decorates_assigned :practice_contests, :groups
  helper_method :calc_rankings

  def index
    @past_contests = Contest.finished.paginate(page: params.fetch(:past_contests_page, 1), per_page: 20)
    @contests = WillPaginate::Collection.create(params[:contest_page] || 1, 20) do |pager|
      contests = Contest.current.select { |contest| contest.visible || current_user.andand.admin? }

      pager.replace contests[pager.offset, pager.per_page]
      pager.total_entries = contests.length
    end

    @upcoming_contests = Contest.upcoming.visible
    @practice_contests = Contest.practicable
                                .visible
                                .order(start_time: :desc)
                                .paginate(page: params.fetch(:practice_contests_page, 1), per_page: 20)
    @groups = Group.all
  end

  def rules
  end

  def results
    @contest = Contest.find(params[:contest_id])
    unless @contest.results_visible? || current_user.andand.admin?
      redirect_to root_path
      return
    end
    @results = @contest.generate_contest_results
    render action: :results, layout: 'results'
  end

  def rankings_practice
  end

  def activity
  end

  def status
    @runs = Run.joins(:user, problem: :contest)
               .where(contests: { practicable: true, visible: true }).where.not(users: { role: User::ADMIN })
               .order('runs.created_at DESC')
               .paginate(per_page: 50, page: params.fetch(:page, 1))
  end

  private

  def calc_rankings(options = {})
    WillPaginate::Collection.create(options[:page] || 1, options[:per_page] || 10) do |pager|
      rankings = User.generate_ranklist(options.merge(offset: pager.offset, limit: pager.per_page)).map do |row|
        OpenStruct.new(
          user: row[0],
          total_points: row[1].to_i,
          total_runs: row[2],
          full_solutions: row[3]
        )
      end

      pager.replace rankings

      pager.total_entries = Run.group('user_id')
                               .select('MAX(created_at) as last_run')
                               .having('last_run > ?', 1.year.ago)
                               .length
    end
  end
end
