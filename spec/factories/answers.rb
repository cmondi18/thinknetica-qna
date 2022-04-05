FactoryBot.define do
  factory :answer do
    body { "Answer_Body" }
  end

  trait :invalid do
    body { nil }
  end
end
