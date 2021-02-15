FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Number.number(digits: 16).to_s }
    credit_card_expiration_date { Array(1..12).sample.to_s + "/" + Array(23..30).sample.to_s }
    result { ["failed", "success"].sample }
  end
end