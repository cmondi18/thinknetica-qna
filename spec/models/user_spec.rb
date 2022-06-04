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

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '12345')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
