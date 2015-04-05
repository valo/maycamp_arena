require 'grader'

describe Grader do
  self.use_transactional_fixtures = false

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

  it "grades two runs simultaniously" do
    run1 = create(:run, status: Run::WAITING)
    run2 = create(:run, status: Run::WAITING)

    pid1 = fork { Grader.new.find_and_grade_run }
    pid2 = fork { Grader.new.find_and_grade_run }

    Process.waitall

    # Make sure the second run will be judged if the 2 runs above fight for the first run
    pid3 = fork { Grader.new.find_and_grade_run }

    Process.waitall

    expect(run1.reload.status).to eq('')
    expect(run2.reload.status).to eq('')
  end
end
