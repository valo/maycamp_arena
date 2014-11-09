require 'docker'

class GradeExecutable
  def initialize(run, prefix)
    @run = run
    @prefix = prefix
  end

  def call
    
  end

  private

  attr_reader :source_code
end
