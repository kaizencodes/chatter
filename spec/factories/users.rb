# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    password { '1234qwer' }
    # password_confirmation { '1234qwer' }
  end
end
