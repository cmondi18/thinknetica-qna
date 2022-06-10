class FilesController < ApplicationController
  before_action :find_record

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    authorize @attachment

    @attachment.purge

    if @attachment.record.is_a?(Answer)
      redirect_to @attachment.record.question, notice: 'Attachment was successfully deleted'
    else
      redirect_to @attachment.record, notice: 'Attachment was successfully deleted'
    end
  end

  private

  def find_record
    @record = ActiveStorage::Attachment.find(params[:id]).record
  end
end