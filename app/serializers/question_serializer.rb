# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :comments
  has_many :links

  has_many :files

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
  end
end
