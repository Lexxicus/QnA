# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if current_user.author?(@file.record)
  end
end
