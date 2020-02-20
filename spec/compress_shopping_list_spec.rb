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
  end
end

