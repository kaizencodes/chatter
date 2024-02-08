# frozen_string_literal: true

require 'rails_helper'
RSpec.describe WeeklySummaryJob, type: :job do
  let(:mailer) { double('mailer', deliver_now: true) }

  describe '#perform' do
    it 'sends a weekly summary email to the user' do
      user = create(:user)
      expect(UserMailer).to receive(:weekly_summary).and_return(mailer)

      WeeklySummaryJob.new.perform(user.id)

      expect(mailer).to have_received(:deliver_now)
    end
  end
end
