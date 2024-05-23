FactoryBot.define do
  factory :product do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    category { "MyString" }
    price_cents { 1 }
    price_currency { "MyString" }
    created_at { "2024-05-23 10:34:41" }
    updated_at { "2024-05-23 10:34:41" }
  end
end
