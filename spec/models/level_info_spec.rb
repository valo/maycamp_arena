describe LevelInfo do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:level) }
  it { is_expected.to validate_numericality_of(:level) }
  it { is_expected.to validate_presence_of(:current_exp) }
  it { is_expected.to validate_numericality_of(:current_exp) }

  describe '#total_exp' do
    let(:level_info) { create(:level_info, current_exp: 100) }

    it 'returns the current experience if you are level 1' do
      expect(level_info.total_exp).to eq(level_info.current_exp)
    end

    it 'returns the total experience of all levels' do
      level_info.level = 3
      expect(level_info.total_exp).to eq(level_info.current_exp + (1 + 2) * LevelInfo::BASE_LEVEL_MULTIPLIER)
    end
  end
end
