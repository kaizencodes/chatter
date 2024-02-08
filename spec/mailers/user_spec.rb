# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'weekly_summary' do
    let(:user) { create(:user) }

    before do
      create(:message, created_at: 1.week.ago - 1.day)
      create(:message, user:, created_at: 1.day.ago)
      create(:message, created_at: 1.hour.ago)
    end

    let(:mail) { UserMailer.weekly_summary(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Your weekly summary')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('2 messages have been exchanged in the last week.')
      expect(mail.body.encoded).to include('1 since your last message on the 1st of February.')
    end

    context 'when the user has not created any messages' do
      let(:mail) { UserMailer.weekly_summary(create(:user)) }

      it 'renders the body' do
        expect(mail.body.encoded).to include('2 messages have been exchanged in the last week.')
        expect(mail.body.encoded).to include('0 since your last message on the 1st of February.')
      end
    end
  end
end
