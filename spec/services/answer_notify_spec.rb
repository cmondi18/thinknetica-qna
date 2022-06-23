require 'rails_helper'

RSpec.describe AnswerNotify do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question) }
  let!(:subscriptions) do
    users.each do |user|
      Subscription.create(user: user, question: question)
    end
  end
  let(:answer) { create(:answer, question: question) }

  it 'sends new answer notify to all users' do
    users.each { |user| expect(AnswerMailer).to receive(:new_answer).with(answer, user).and_call_original }

    subject.send_notify(answer)
  end
end