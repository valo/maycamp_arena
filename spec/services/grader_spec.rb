require 'grader'

describe Grader do
  self.use_transactional_tests = false

  let(:grade_run) { double(GradeRun) }
  let(:sync_tests) { double(SyncTests) }

  before(:each) do
    DatabaseCleaner.strategy = :truncation

    allow(SyncTests).to receive(:new).and_return(sync_tests)
    allow(sync_tests).to receive(:call).and_return(Time.now)
  end

  after(:each) do
    DatabaseCleaner.clean
  end

  it "calls the grader run service object with the pending run to be tested" do
    run1 = create(:run, status: Run::WAITING)

    expect(GradeRun).to receive(:new).with(run1).and_return(grade_run)
    expect(grade_run).to receive(:call).and_return(true)

    Grader.new.find_and_grade_run
  end
end
