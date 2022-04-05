class AnswersController < ApplicationController
  before_action :find_question, only: %i[new create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)

    if @answer.save
      redirect_to @question
    else
      redirect_to @question, alert: "Can't submit answer with empty body"
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
