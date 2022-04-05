FactoryBot.define do
  factory :answer do
    body { "Answer_Body" }
    question { create(:question) }
    user { create(:user) }
  end

  trait :invalid do
    body { nil }
  end
end
