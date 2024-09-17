require 'rails_helper'

RSpec.describe EnglishFood, type: :model do
  describe 'validations' do
    subject { create(:english_food) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:prefecture) }
    it { should validate_presence_of(:history) }
    it { should validate_presence_of(:image_url) }
    it { should validate_presence_of(:detail_url) }
    # 大文字・小文字を区別しない一意性のテスト
    it { should validate_uniqueness_of(:detail_url).case_insensitive }
  end

  describe '.search' do
    let!(:food1) { create(:english_food, name: 'Ehomaki / Makizushi (Sushi rolls)', prefecture: 'Osaka Prefecture', detail_url: 'https://example.com/1') }
    let!(:food2) { create(:english_food, name: 'Tempura', prefecture: 'Tokyo Prefecture', detail_url: 'https://example.com/2') }
    let!(:food3) { create(:english_food, name: 'Ramen', prefecture: 'Hokkaido Prefecture', detail_url: 'https://example.com/3') }

    context 'when searching by name' do
      it 'returns foods matching the name keyword' do
        expect(EnglishFood.search('Ehomaki', '')).to include(food1)
        expect(EnglishFood.search('Ehomaki', '')).not_to include(food2, food3)
      end
    end

    context 'when searching by prefecture' do
      it 'returns foods matching the prefecture keyword' do
        expect(EnglishFood.search('', 'Tokyo Prefecture')).to include(food2)
        expect(EnglishFood.search('', 'Tokyo Prefecture')).not_to include(food1, food3)
      end
    end

    context 'when searching by name and prefecture' do
      it 'returns foods matching both keywords' do
        expect(EnglishFood.search('Ramen', 'Hokkaido Prefecture')).to include(food3)
        expect(EnglishFood.search('Ramen', 'Hokkaido Prefecture')).not_to include(food1, food2)
      end
    end

    context 'when no keyword is provided' do
      it 'returns all foods' do
        expect(EnglishFood.search('', '')).to include(food1, food2, food3)
      end
    end
  end

  describe '#image_filename' do
    it 'returns the filename without extension and removes "-1"' do
      food = build(:english_food, image_url: 'https://example.com/path/to/image-1.jpg')
      expect(food.image_filename).to eq('image')
    end

    it 'returns the filename without changes if "-1" is not present' do
      food = build(:english_food, image_url: 'https://example.com/path/to/image.jpg')
      expect(food.image_filename).to eq('image')
    end
  end
end