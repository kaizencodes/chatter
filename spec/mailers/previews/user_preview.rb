# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user/weekly_summary

  def weekly_summary
    user = User.first
    UserMailer.weekly_summary(user)
  end
end
