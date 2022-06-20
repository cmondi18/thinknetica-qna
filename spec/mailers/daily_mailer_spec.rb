require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3)}
    let(:mail) { DailyMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily digest of all new questions")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Today created questions digest")

      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end
  end
end
