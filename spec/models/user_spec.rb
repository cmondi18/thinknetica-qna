require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }

  context 'author_of returns true' do
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }

    it 'when user is author of question' do
      expect(user.author_of?(question)).to eq true
    end

    it 'when user is author of answer' do
      expect(user.author_of?(question)).to eq true
    end
  end

  context 'author_of returns false' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }

    it 'when user is not author of question' do
      expect(user.author_of?(question)).to eq false
    end

    it 'when user is not author of answer' do
      expect(user.author_of?(question)).to eq false
    end
  end
end
