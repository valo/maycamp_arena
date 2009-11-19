module ShellUtils
  def verbose_system(cmd)
    puts cmd
    system cmd
    puts "status: #{$?.exitstatus}"
  end

  def get_config
    config = `hostname`.chomp
    grader_conf = YAML.load_file(File.join(RAILS_ROOT, "config/grader.yml"))
    puts "Reading configuration for server #{config}"
    if !grader_conf[config]
      puts "Cannot find configuration for #{config}. Check your config/grader.yml"
      exit 1
    end
    grader_conf[config].with_indifferent_access
  end
end