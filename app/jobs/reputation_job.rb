class ReputationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ReputationService.calculate(object_id)
  end
end
