# frozen_string_literal: true

class WeeklySummariesJob
  include Sidekiq::Job

  def perform
    User.ids.each do |id|
      WeeklySummaryJob.perform_async(id)
    end
  end
end
