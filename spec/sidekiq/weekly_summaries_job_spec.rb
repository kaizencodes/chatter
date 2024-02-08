# frozen_string_literal: true

require 'rails_helper'
RSpec.describe WeeklySummariesJob, type: :job do
  describe '#perform' do
    it 'enqueues a WeeklySummaryJob for each user' do
      user1 = create(:user)
      user2 = create(:user)

      expect(WeeklySummaryJob).to receive(:perform_async).with(user1.id)
      expect(WeeklySummaryJob).to receive(:perform_async).with(user2.id)

      WeeklySummariesJob.new.perform
    end
  end
end
