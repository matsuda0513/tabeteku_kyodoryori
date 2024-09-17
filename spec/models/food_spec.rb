# spec/models/food_spec.rb
require 'rails_helper'

RSpec.describe Food, type: :model do
  describe 'validations' do
    subject { create(:food) } # FactoryBot を使って有効なレコードを準備
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:prefecture) }
    it { should validate_presence_of(:history) }
    it { should validate_presence_of(:image_url) }
    it { should validate_presence_of(:detail_url) }

    # 一意性検証
    it 'validates uniqueness of detail_url (case-insensitive)' do
      # データベース内に既存のFoodレコードを作成
      create(:food, detail_url: 'https://example.com')
      
      # 新たに作成するレコードが大文字小文字を区別せず一意性を持つことを確認
      is_expected.to validate_uniqueness_of(:detail_url).case_insensitive
    end
  end

  describe '.search' do
    let!(:food1) { create(:food, name: '恵方巻き／巻きずし（えほうまき／まきずし）', prefecture: '大阪府', detail_url: 'https://example.com/1') }
    let!(:food2) { create(:food, name: 'てんぷら', prefecture: '東京都', detail_url: 'https://example.com/2') }
    let!(:food3) { create(:food, name: 'ラーメン', prefecture: '北海道', detail_url: 'https://example.com/3') }  

    context 'when searching by name' do
      it 'returns foods matching the name keyword' do
        expect(Food.search('恵方巻き', '')).to include(food1)
        expect(Food.search('恵方巻き', '')).not_to include(food2, food3)
      end
    end

    context 'when searching by prefecture' do
      it 'returns foods matching the prefecture keyword' do
        expect(Food.search('', '大阪府')).to include(food1)
        expect(Food.search('', '大阪府')).not_to include(food2, food3)
      end
    end

    context 'when searching by name and prefecture' do
      it 'returns foods matching both keywords' do
        expect(Food.search('ラーメン', '北海道')).to include(food3)
        expect(Food.search('ラーメン', '北海道')).not_to include(food1, food2)
      end
    end

    context 'when no keyword is provided' do
      it 'returns all foods' do
        expect(Food.search('', '')).to include(food1, food2, food3)
      end
    end
  end

  describe '#image_filename' do
    it 'returns the filename without extension and removes "-1"' do
      food = build(:food, image_url: 'https://example.com/path/to/image-1.jpg')
      expect(food.image_filename).to eq('image')
    end

    it 'returns the filename without changes if "-1" is not present' do
      food = build(:food, image_url: 'https://example.com/path/to/image.jpg')
      expect(food.image_filename).to eq('image')
    end
  end
end