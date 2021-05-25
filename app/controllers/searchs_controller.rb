# frozen_string_literal: true

class SearchsController < ApplicationController
  skip_load_and_authorize_resource
  helper_method :search_params
  SEARCH_VIEW = %w[All Question Answer Comment User].freeze

  def search
    if SEARCH_VIEW.include?(search_params[:resource]) && search_params[:query].present?
      @search_results = klass_name(search_params[:resource]).search(search_params[:query])
    else
      redirect_to root_path, alert: 'Search can`t be blanc'
    end
  end

  private

  def klass_name(resource)
    resource == 'All' ? ThinkingSphinx : resource.classify.constantize
  end

  def search_params
    @search_params = params.permit(:query, :resource, :commit)
  end
end
