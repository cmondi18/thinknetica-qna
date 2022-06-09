class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy mark_as_best]

  after_action :publish_answer, only: %i[create]

  authorize_resource

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.assign_attributes(question: @question)

    respond_to do |format|
      if @answer.save
        format.json do
          render json: [answer: @answer,
                        links: @answer.links,
                        files: @answer.files.collect { |f| f.filename.to_s }]
        end
      else
        format.json do
          render json: @answer.errors.full_messages,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    @question = @answer.question
    @answer.destroy
  end

  def mark_as_best
    if current_user&.author_of?(@answer.question)
      @answer.mark_as_best!
    else
      flash.now[:alert] = 'You must be author of main question'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                   links_attributes: [:name, :url, :_destroy])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast 'answers',
                                 answer: @answer.body,
                                 user_id: @answer.user_id
  end
end
