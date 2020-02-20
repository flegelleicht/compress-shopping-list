require 'shopping_list_entry_parser'

RSpec.describe ShoppingListEntryParser, "::parse" do
  context "with a simple entry" do
    let(:value) { rand(200..567) }
    let(:unit) { ['g', 'kg', 'l'].sample }
    let(:text) { ['A', 'B', 'C', 'D'].sample }
    let(:entry) { "#{value}#{unit} #{text}" }

    it "returns the correct value, unit and text" do
      expect(
        ShoppingListEntryParser.parse(entry)
      ).to eq({value: value, unit: unit, text: text})
    end
  end
end

