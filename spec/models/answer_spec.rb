require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_one(:question_with_best_answer).dependent(:nullify) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  context 'set best answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:reward) { create(:reward, question: question) }
    let(:answer) { create(:answer, question: question) }

    it 'user is author of object' do
      answer.mark_as_best!
      expect(question.best_answer).to eq answer
      expect(question.reward.answer).to eq answer
    end
  end

  describe 'notify author of question' do
    let(:question) { create(:question) }
    let(:answer) { build(:answer, question: question) }

    it 'calls AnswerNotifyJob' do
      expect(AnswerNotifyJob).to receive(:perform_later).with(answer)

      answer.save!
    end
  end
end
