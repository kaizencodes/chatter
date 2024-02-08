# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def weekly_summary(user)
    @user = user
    @total_message_count = total_message_count
    @since_last_message_count = since_last_message_count(user)

    mail(to: @user.email, subject: 'Your weekly summary')
  end

  private

  def total_message_count
    Message.where('created_at > ?', 1.week.ago).count
  end

  def since_last_message_count(user)
    last_message_timestamp = user.messages.last.created_at
    Message.where('created_at > ?', last_message_timestamp).count
  end
end
