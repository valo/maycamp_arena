describe IncreaseExpForUser do
  let(:user) { create(:user) }
  let(:increase_exp_for_user) { IncreaseExpForUser.new(user, exp) }

  describe '#call' do
    let(:exp) { 100 }

    context 'when not increasing level' do
      it 'increases the exp of the user' do
        increase_exp_for_user.call

        expect(user.level_info.current_exp).to be(exp)
      end
    end

    context 'when increasing level' do
      let(:exp) { 500 }

      it 'keeps the overflowing exp' do
        increase_exp_for_user.call

        expect(user.level_info.current_exp).to be(0)
      end

      it 'increases the level of the user' do
        increase_exp_for_user.call

        expect(user.level_info.level).to be(2)
      end
    end

    context 'when increasing multiple levels' do
      let(:exp) { 4000 }

      it 'keeps the overflowing exp' do
        increase_exp_for_user.call

        expect(user.level_info.reload.current_exp).to be(1000)
      end

      it 'increases the level of the user' do
        increase_exp_for_user.call

        expect(user.level_info.level).to be(4)
      end
    end
  end
end
