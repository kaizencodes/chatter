# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    content { 'Some text' }

    association :user
  end
end
