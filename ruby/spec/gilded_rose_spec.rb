require 'gilded_rose'

describe '2+2' do
  it 'equals 4' do
    expect(2+2).to eq 4
  end
end

describe 'Aged Brie' do
  it 'increases in Quality as it matures' do
    aged_brie = Item.new('Aged Brie', 30, 1)
    gilded_rose = GildedRose.new([aged_brie])

    expect { gilded_rose.update_quality }.to change { aged_brie.quality }.by 1
  end

  context 'when the expire date hits' do
    it 'increases in quality by 2' do
      aged_brie = Item.new('Aged Brie', 0, 1)
      gilded_rose = GildedRose.new([aged_brie])

      expect { gilded_rose.update_quality }.to change { aged_brie.quality }.by 2
    end
  end
end
