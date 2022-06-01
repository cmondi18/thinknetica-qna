module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_commentable, only: %i[comment]
  end

  def comment
    comment = @commentable.comments.new(commentable_params)
    comment.assign_attributes(user: current_user)

    respond_to do |format|
      if comment.save
        format.json do
          render json: [comment: comment,
                        author: comment.user]
        end
      else
        format.json do
          render json: comment.errors.full_messages,
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end
end
