FactoryBot.define do
  factory :english_food do
    name { "Ehomaki / Makizushi (Sushi rolls)" }
    prefecture { "Osaka Prefecture" }
    history { "History of Ehomaki" }
    image_url { "https://example.com/image.jpg" }
    detail_url { "https://example.com/1" }
  end
end