describe Run do
  describe "#update_time_and_mem" do
    let(:run) { create(:run) }

    it "saves the max time and memory from the log" do
      run.log = "Used time: 1\nUsed time: 2\nUsed mem: 6\nUsed mem: 5"

      run.update_time_and_mem

      expect(run.max_time).to eq(2)
      expect(run.max_memory).to eq(6)
    end

    it "handles invalid UTF-8 characters" do
      run.log = "Used time: 1234\255"

      run.update_time_and_mem

      expect(run.max_time).to eq(1234)
    end
  end
end
