# -*- encoding : utf-8 -*-
require 'ostruct'

class MainController < ApplicationController
  layout "main", :except => :results
  before_filter :check_user_profile
  
  def index
    @contests = Contest.current.select {|contest| contest.visible or current_user.andand.admin?}
    @upcoming_contests = Contest.upcoming.select {|contest| contest.visible or current_user.andand.admin?}
    @practice_contests = Contest.practicable.select {|contest| contest.visible or current_user.andand.admin?}.reverse
    @top_scores = User.rating_ordering(10)
  end
  
  def results
    case params[:contest_type]
    when "ExternalContestResult"
      @contest = ExternalContest.find(params[:contest_id], :include => { :contest_results => { :rating_change => :previous_rating_change, :user => :rating_changes } })
      
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
    @rankings = calc_rankings(:page => params[:page], :per_page => 25)
  end
  
  def activity
    @week_rankings = calc_rankings(:since => 7.days.ago, :only_active => true, :per_page => User.count)
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
    @runs = Run.paginate(:per_page => 50,
                         :include => { :user => {} , :problem => :contest },
                         :page => params[:page],
                         :select => (Run.column_names - ["log", "source_code"]).map { |c| "runs.#{c}" }.join(","),
                         :conditions => ["contests.practicable AND contests.visible AND NOT users.admin"],
                         :order => "runs.created_at DESC")
  end

  def problems
    @problems = Problem.paginate(:page => params[:page],
                                 :per_page => 50,
                                 :include => [:contest],
                                 :conditions => ["contests.visible AND contests.practicable"])
  end
  
  def problem_runs
    @problem = Problem.find(params[:id], :include => [:contest], :conditions => ["contests.visible AND contests.practicable"])
    @runs = Run.paginate(:include => :user, :conditions => ["NOT users.admin AND runs.problem_id = ?", @problem.id], :per_page => 50, :page => params[:page])
  end
  
  private
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
        
        pager.total_entries = User.count
      end
    end
end
