require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin:true), create(:answer))
      expect(subject).to permit(User.new(admin:true), create(:question))
    end

    it 'grants access if user is author of parent resource' do
      expect(subject).to permit(user, create(:answer, user: user))
      expect(subject).to permit(user, create(:question, user: user))

    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:answer))
      expect(subject).not_to permit(user, create(:question))
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end
end
