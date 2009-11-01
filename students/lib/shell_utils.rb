module ShellUtils
  def verbose_system(cmd)
    puts cmd
    system cmd
    puts "status: #{$?.exitstatus}"
  end
end