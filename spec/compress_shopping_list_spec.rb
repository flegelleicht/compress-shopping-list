require 'float_extension'
require 'compress_shopping_list'

RSpec.describe CompressShoppingList, "::compress" do
  context "with an empty list" do
    it "returns an empty list" do
      expect(
        CompressShoppingList.compress([])
      ).to eq []
    end
  end

  context "with a list with one entry" do
    let(:list) { ["200g Zucker"] }
    it "returns a one-entry list" do
      expect(
        CompressShoppingList.compress(list)
      ).to eq list
    end
  end

  context "with a list with all equal" do
    context "unitless entries" do
      let(:entry) { 'Zucker' }
      let(:list) { Array.new(rand(2..8)).map{ entry } }

      it "returns a list with a count and the entry" do
        expected = "#{list.size}x #{entry}"
        expect(
          CompressShoppingList.compress(list)
        ).to eq([expected])
      end
    end

    context "entries with matching units" do
      let(:size) { rand(2..8) }
      let(:unit) { 'g' }
      let(:values) { Array.new(size).map{ rand(100..150) } }
      let(:entry) { 'Zucker' }
      let(:list) { values.map{|value| "#{value}#{unit} #{entry}" } }

      it "returns a list with one entry and summed up value" do
        expected = "#{values.reduce(&:+)}#{unit} #{entry}"

        expect(
          CompressShoppingList.compress(list)
        ).to eq([expected])
      end
    end
    
    context "entries with matching unit (grams) and sum below 1 kilogram" do
      let(:size) { rand(2..6) }
      let(:unit) { 'g' }
      let(:values) { Array.new(size).map{ rand(100..150) } }
      let(:entry) { 'Zucker' }
      let(:list) { values.map{|value| "#{value}#{unit} #{entry}" } }

      it "returns a list with one entry and summed up value" do
        expected = "#{values.reduce(&:+)}#{unit} #{entry}"

        expect(
          CompressShoppingList.compress(list)
        ).to eq([expected])
      end
    end

    context "entries with matching unit (grams) and sum over 1 kilogram" do
      let(:size) { rand(2..6) }
      let(:unit) { 'g' }
      let(:values) { Array.new(size).map{ rand(500..650) } }
      let(:entry) { 'Zucker' }
      let(:list) { values.map{|value| "#{value}#{unit} #{entry}" } }

      it "returns a list with one entry and summed up value" do
        sum = values.reduce(&:+)
        sum_in_kg = (sum.to_f / 1000.0).round(3)
        expected = "#{sum_in_kg.germanize}#{unit} #{entry}"

        expect(
          CompressShoppingList.compress(list)
        ).to eq([expected])
      end
    end

    context "entries with mixed unit (grams and kilograms)" do
      let(:list) { ["200g Zucker", "1kg Zucker", "500g Zucker"] }

      it "returns a list with one entry and a summed up value in kilograms" do
        expected = '1,7kg Zucker'
        expect(
          CompressShoppingList.compress(list)
        ).to eq([expected])
      end
    end
  end

#  context "with a list with different entries:", broken: true do
#    context "same text, but different values and units" do
#      let(:values) { Array.new(rand(2..10).map{ rand(100..200) }) }
#      let(:text) { 'Zucker' }
#      let(:list) { Array.new(rand(2..8)).map{ entry } }
#
#      it "returns a list with a count and the entry" do
#        expected = "#{list.size}x #{entry}"
#        expect(
#          CompressShoppingList.compress(list)
#        ).to eq([expected])
#      end
#    end
#  end
end

