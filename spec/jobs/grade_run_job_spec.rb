describe GradeRunJob do
  let(:run) { create(:run) }
  let(:tests) { 1 }
  let(:grade_run) { instance_double(GradeRun) }

  it 'calls GradeRun with the correct parameters' do
    expect(GradeRun).to receive(:new).with(run, tests).and_return(grade_run)
    expect(grade_run).to receive(:call)

    GradeRunJob.perform_now(run.id, tests)
  end
end
