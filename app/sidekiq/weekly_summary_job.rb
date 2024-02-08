# frozen_string_literal: true

class WeeklySummaryJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.weekly_summary(user).deliver_now
  end
end
