# frozen_string_literal: true

class ReputationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    ReputationService.calculate(object_id)
  end
end
