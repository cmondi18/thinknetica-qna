# Preview all emails at http://localhost:3000/rails/mailers/answer
class AnswerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answer/send_answer
  def send
    AnswerMailer.new_answer
  end
end
