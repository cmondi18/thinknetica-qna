require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is exists' do
      expect(subject).to permit(user)
    end

    it 'denies access if user is guest' do
      expect(subject).to_not permit(nil)
    end
  end
end
