require 'shopping_list_entry_parser'

class CompressShoppingList
  class << self
    def compress(list = [])
      return list if list.empty?
      return list.clone if list.size == 1
      return ["#{list.count}x #{list.first}"] if all_same?(list)

      parsed = list.map{|e| ShoppingListEntryParser.parse(e) }
      grouped = group_parsed_entries_by_text(parsed)
      compressed = grouped.map do |entry, values|
        sum = values.reduce(0){ |acc, v| acc + v[:value].to_i }
        "#{sum}#{values.first[:unit]} #{entry}"
      end

      compressed
    end

    private

    def all_same?(list)
      list.all?{|e| e == list.first }
    end

    def group_parsed_entries_by_text(parsed)
      grouped = {}

      parsed.each do |entry|
        v, u, t = entry[:value], entry[:unit], entry[:text]
        grouped[t] = [] unless grouped.include?(t)
        grouped[t] << {value: v, unit: u}
      end

      grouped
    end
  end
end

