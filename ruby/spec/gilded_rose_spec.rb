require 'spec_helper'
require 'gilded_rose'
require 'pry'

describe 'Aged Brie' do
  it 'reduces the days left to sell it by 1' do
    aged_brie = Item.new('Aged Brie', 10, 10)

    expect { update_quality_of(aged_brie) }.to change { aged_brie.sell_in }.by -1
  end

  it 'increases in Quality as it matures' do
    aged_brie = Item.new('Aged Brie', 30, 1)

    expect { update_quality_of(aged_brie)}.to change { aged_brie.quality }.by 1
  end

  context 'when there is one day left to sell' do
    it 'increases in quality by 2' do
      aged_brie = Item.new('Aged Brie', 1, 4)

      expect { update_quality_of(aged_brie) }.to change { aged_brie.quality }.by 1
    end
  end

  context 'when the expire date hits' do
    it 'increases in quality by 2' do
      aged_brie = Item.new('Aged Brie', 0, 1)

      expect { update_quality_of(aged_brie) }.to change { aged_brie.quality }.by 2
    end
  end

  context 'when the expire date has passed' do
    it 'increases in quality by 2' do
      aged_brie = Item.new('Aged Brie', -1, 1)

      expect { update_quality_of(aged_brie) }.to change { aged_brie.quality }.by 2
    end

    context 'and the quality is 50' do
      it 'does not increase in quality' do
        aged_brie = Item.new('Aged Brie', -1, 50)

        expect { update_quality_of(aged_brie) }.not_to change { aged_brie.quality }.from 50
      end
    end
  end

  context 'when the quality is 50' do
    it 'does not increase in quality' do
      aged_brie = Item.new('Aged Brie', 1, 50)

      expect { update_quality_of(aged_brie) }.not_to change { aged_brie.quality }.from 50
    end
  end
end

describe 'Sulfuras, Hand of Ragnaros' do
  it 'will never decrease or increase in quality' do
    sulfuras = Item.new('Sulfuras, Hand of Ragnaros', 10, 80)

    expect { update_quality_of(sulfuras) }.not_to change { sulfuras.quality }
  end

  it 'will never reduce the sell by date' do
    sulfuras = Item.new('Sulfuras, Hand of Ragnaros', 10, 80)

    expect { update_quality_of(sulfuras)}.not_to change { sulfuras.sell_in }
  end
end

describe 'Normal Item' do
  it 'reduces the days left to sell it by 1' do
    normal_item = normal_item(sell_in: 10, quality: 10)

    expect { update_quality_of(normal_item) }
      .to change { normal_item.sell_in }.by -1
  end

  it 'decreases quality when it gets older' do
    normal_item = normal_item(sell_in: 10, quality: 10)

    expect { update_quality_of(normal_item) }.to change { normal_item.quality }.by -1
  end

  it 'will never have a quality less than 0' do
    normal_item = normal_item(sell_in: 10, quality: 0)

    expect { update_quality_of(normal_item) }.not_to change { normal_item.quality }
  end

  context 'when the sell by day has passed' do
    it 'decrease quality twice as fast' do
      normal_item = normal_item(sell_in: 0, quality: 50)

      expect { update_quality_of(normal_item) }.to change { normal_item.quality }.by -2
    end
  end

  context 'when it has expired' do
    context 'and the quality is already 0' do
      it 'does not change in quality' do
        normal_item = normal_item(sell_in: -1, quality: 0)

        expect { update_quality_of(normal_item) }.not_to change { normal_item.quality }.from 0
      end
    end
  end

  def normal_item(sell_in:, quality:)
    Item.new('Normal Item', sell_in, quality)
  end
end

describe 'Backstage passes' do
  context 'when the sell by date is between 10 and 6 days away' do
    it 'increases in quality twice as fast' do
      backstage_pass = backstage_pass(sell_in: 10, quality: 10)

      expect { update_quality_of(backstage_pass) }.to change { backstage_pass.quality }.by 2
    end
  end

  context 'when the sell by date is between 5 and 0 days away' do
    it 'increases in quality three times as fast' do
      backstage_pass = backstage_pass(sell_in: 5, quality: 10)

      expect { update_quality_of(backstage_pass) }.to change { backstage_pass.quality }.by 3
    end
  end

  context 'when the sell by date has been hit' do
    it 'drop the quality to 0' do
      backstage_pass = backstage_pass(sell_in: 0, quality: 10)

      expect { update_quality_of(backstage_pass) }.to change { backstage_pass.quality }.to 0
    end
  end

  it 'reduces the days left to sell it by 1' do
    backstage_pass = backstage_pass(sell_in: 10, quality: 10)

    expect { update_quality_of(backstage_pass) }.to change { backstage_pass.sell_in }.by -1
  end

  context 'when the concert has finished' do
    it 'has no quality' do
      backstage_pass = backstage_pass(sell_in: -1, quality: 10)

      expect { update_quality_of(backstage_pass) }.to change { backstage_pass.quality }.to 0
    end

    context 'and the quality is already 0' do
      it 'should not change from 0' do
        backstage_pass = backstage_pass(sell_in: -1, quality: 0)

        expect { update_quality_of(backstage_pass) }.to_not change { backstage_pass.quality }.from 0
      end
    end
  end

  context 'when there are precisely 11 days left to sell' do
    it 'increases quality by 1' do
      backstage_pass = backstage_pass(sell_in: 11, quality: 3)

      expect { update_quality_of(backstage_pass) }.to change { backstage_pass.quality }.by 1
    end
  end

  context 'when there are precisely 6 days left to sell' do
    it 'increases quality by 2' do
      backstage_pass = backstage_pass(sell_in: 6, quality: 3)

      expect { update_quality_of(backstage_pass) }.to change { backstage_pass.quality }.by 2
    end
  end

  def backstage_pass(sell_in:, quality:)
    Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality)
  end
end

def update_quality_of(item)
  gilded_rose = GildedRose.new([item])
  gilded_rose.update_quality
end
