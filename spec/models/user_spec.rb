require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'verification of user authorship' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer) }

    it 'user is author of object' do
      expect(user).to be_author_of(question)
    end

    it 'user is not author of object' do
      expect(user).to_not be_author_of(answer)
    end
  end

  context 'verification of user rewards' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:rewards) { create_list(:reward, 3, answer: answer) }
    let(:another_reward) { create(:reward) }

    it 'returns users reward' do
      expect(user.rewards).to match_array(rewards)
    end
  end

  context 'verification of user voting able' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:voted_answer) { create(:answer) }
    let(:own_question) { create(:question, user: user) }
    let(:vote) { create(:vote, votable: voted_answer, user: user) }

    it 'user is author of votable' do
      expect(user).to_not be_able_to_vote(own_question)
    end

    it 'user is not author of votable' do
      expect(user).to be_able_to_vote(question)
    end

    it 'user already voted' do
      vote.reload

      expect(user).to_not be_able_to_vote(voted_answer)
    end

    it 'user already voted and able to cancel' do
      vote.reload

      expect(user).to be_able_to_cancel_vote(voted_answer)
    end

    it 'user did\'t vote and tries to cancel' do
      expect(user).to_not be_able_to_cancel_vote(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth service' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
