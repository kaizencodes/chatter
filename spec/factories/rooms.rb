FactoryBot.define do
  factory :room do
    sequence(:name) { |i| "room_#{i}" }
  end
end
