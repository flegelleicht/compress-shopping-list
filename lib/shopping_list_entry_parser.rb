class ShoppingListEntryParser
  class << self
    def parse(entry = "")
      value, unit, rest = /^\s*(\d*)(g|kg|l)\s+(.*)$/.match(entry).captures

      {
        value: value.to_i,
        unit: unit.chomp,
        text: rest.chomp
      }
    end
  end
end

