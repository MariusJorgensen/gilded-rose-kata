require 'gilded_rose'
require 'pry'

describe 'Aged Brie' do
  it 'increases in Quality as it matures' do
    aged_brie = Item.new('Aged Brie', 30, 1)
    gilded_rose = GildedRose.new([aged_brie])

    expect { gilded_rose.update_quality }.to change { aged_brie.quality }
  end

  context 'when the expire date hits' do
    it 'increases in quality by 2' do
      aged_brie = Item.new('Aged Brie', 0, 1)
      gilded_rose = GildedRose.new([aged_brie])

      expect { gilded_rose.update_quality }.to change { aged_brie.quality }.by 2
    end
  end

  context 'when the expire date has passed' do
    it 'increases in quality by 2' do
      aged_brie = Item.new('Aged Brie', -1, 1)
      gilded_rose = GildedRose.new([aged_brie])

      expect { gilded_rose.update_quality }.to change { aged_brie.quality }.by 2
    end
  end

  context 'when the quality is 50' do
    it 'does not increase in quality' do
      aged_brie = Item.new('Aged Brie', 1, 50)
      gilded_rose = GildedRose.new([aged_brie])

      expect { gilded_rose.update_quality }.not_to change { aged_brie.quality }.from 50
    end
  end
end

describe 'Sulfuras, Hand of Ragnaros' do
  it 'will never decrease or increase in quality' do
    sulfuras = Item.new('Sulfuras, Hand of Ragnaros', 10, 80)
    gilded_rose = GildedRose.new([sulfuras])

    expect { gilded_rose.update_quality }.not_to change { sulfuras.quality }
  end
end

describe 'Normal Item' do

  it 'decreases quality when it gets older' do
    normal_item = Item.new('Normal Item', 10, 10)
    gilded_rose = GildedRose.new([normal_item])

    expect { gilded_rose.update_quality }.to change { normal_item.quality }.by -1
  end

  it 'will never have a quality less than 0' do
    normal_item = Item.new('Normal Item', 10, 0)
    gilded_rose = GildedRose.new([normal_item])

    expect { gilded_rose.update_quality }.not_to change { normal_item.quality }
  end

  context 'when the sell by day has passed' do
    it 'decrease quality twice as fast' do
      normal_item = Item.new('Normal Item', 0, 50)
      gilded_rose = GildedRose.new([normal_item])

      expect { gilded_rose.update_quality }.to change { normal_item.quality }.by -2
    end
  end



end
