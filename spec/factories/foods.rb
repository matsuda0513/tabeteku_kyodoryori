FactoryBot.define do
  factory :food do
    name { "Test Food" }
    prefecture { "Test Prefecture" }
    history { "Test history about the food." }
    image_url { "https://example.com/path/to/image.jpg" }
    detail_url { "https://example.com/detail" }
  end
end