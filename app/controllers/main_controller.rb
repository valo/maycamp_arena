# -*- encoding : utf-8 -*-
require 'ostruct'

class MainController < ApplicationController
  layout "main", :except => :results
  before_filter :check_user_profile


    def index
        @sort_contests = {}
        @contest_groups = ContestGroup.all()

        unless @contest_groups.blank?
            @contest_groups.each do |g|
                group_contests = Contest.finished.where(:contest_group_id => g.id).order(created_at: :desc).all
                @sort_contests["#{g.id}"] = group_contests
            end
        else
            @sort_contests["1"] = Contest.finished.order(created_at: :desc).all
        end

        @contests = WillPaginate::Collection.create(params[:contest_page] || 1, 20) do |pager|
            contests = Contest.current.select {|contest| contest.visible or current_user.andand.admin?}
            pager.replace contests[pager.offset, pager.per_page]
            pager.total_entries = contests.length
        end

        @upcoming_contests = Contest.upcoming.select {|contest| contest.visible or current_user.andand.admin?}

        @practice_contests = WillPaginate::Collection.create(params[:practice_contests_page] || 1, 20) do |pager|
            practice_contests = Contest.practicable.select {|contest| contest.visible or current_user.andand.admin?}.reverse
            pager.replace (practice_contests[pager.offset, pager.per_page] || [])
            pager.total_entries = practice_contests.length
        end
  end


  def rules
  end

  def results
    case params[:contest_type]
    when "ExternalContestResult"
      @contest = ExternalContest.includes(:contest_results => { :rating_change => :previous_rating_change, :user => :rating_changes }).find(params[:contest_id])

      render :action => :external_results, :layout => "results"
    else
      @contest = Contest.find(params[:contest_id])
      if !(@contest.results_visible? or current_user.andand.admin?)
        redirect_to root_path
        return
      end
      @results = @contest.generate_contest_results
      @ratings = @results.map { |result| @contest.rating_changes.detect { |change| change.user == result.second } }
      render :action => :results, :layout => "results"
    end
  end

  def rankings
    @rankings = User.rating_ordering
  end

  def rankings_practice
  end

  def activity
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

  def status
    @runs = Run.includes(:user, { :problem => :contest }).
                where(:contests => { :practicable => true, :visible => true }).where.not(:users => { :role => User::ADMIN }).
                order("runs.created_at DESC").
                paginate(:per_page => 50,
                         :page => params.fetch(:page, 1))
  end

  def problems
    @problems = Problem.includes(:contest).
                        where(:contests => { :visible => true, :practicable => true }).
                        paginate(:page => params[:page],
                                 :per_page => 50)
  end

  def problem_runs
    @problem = Problem.includes(:contest).where(:contests => { :visible => true, :practicable => true }).find(params[:id])
    @runs = Run.includes(:user).
                where.not(:users => { :role => User::ADMIN }).where(:problem => @problem.id).
                order("runs.created_at DESC").
                paginate(:per_page => 50, :page => params.fetch(:page, 1))
  end

  private
    helper_method :calc_rankings
    def calc_rankings(options = {})
      WillPaginate::Collection.create(options[:page] || 1, options[:per_page] || 10) do |pager|
        rankings = User.generate_ranklist(options.merge(:offset => pager.offset, :limit => pager.per_page)).map do |row|
          OpenStruct.new(
            :user => row[0],
            :total_points => row[1].to_i,
            :total_runs => row[2],
            :full_solutions => row[3],
            :rating => row[4])
        end

        pager.replace rankings

        pager.total_entries = Run.group("user_id").select("MAX(created_at) as last_run").having("last_run > ?", 1.year.ago).length
      end
    end
end
