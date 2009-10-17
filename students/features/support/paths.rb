module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      '/'
    when /the login page/
      login_path
    when /the signup page/
      signup_path
    when /the contest list in the admin panel/
      admin_contests_path
    when /the contest edit page in the admin panel/
      edit_admin_contest_path
    when /the problem list in the admin panel/
      admin_contest_problems_path
    when /the problem view page in the admin panel/
      admin_contest_problem_path
    when /the runs list on the admin panel/
      admin_contest_problem_runs_path
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
