require 'shopping_list_entry_parser'

class CompressShoppingList
  class << self
    def compress(list = [])
      return [] if list.empty?
      return list.clone if list.size == 1
      return ["#{list.count}x #{list.first}"] if all_same?(list)

      parsed = list.map{|e| ShoppingListEntryParser.parse(e) }
      grouped = group_parsed_entries_by_text(parsed)
      compressed = grouped.map do |entry, values|
        sum = values.reduce(0){ |acc, v| acc + v[:value].to_i }
        "#{sum}#{values.first[:unit]} #{entry}"
      end
      compressed = compress_values_and_units(grouped)

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

    def all_same_unit?(values_and_units)
      values_and_units.all?{ |v| v[:unit] == values_and_units.first[:unit] }
    end

    def compress_values_and_units(grouped)
      grouped.map do |entry, values|
        if all_same_unit?(values)
          sum = values.reduce(0){ |acc, v| acc + v[:value].to_i }
          sum = (sum.to_f / 1000.0).round(3).germanize if values.first[:unit] == 'g' && sum >= 1000
          "#{sum}#{values.first[:unit]} #{entry}"
        else
          unit_groups = {}
          values.each do |value|
            v, u = value[:value], value[:unit]
            unit_groups[u] = [] unless unit_groups.include?(u)
            unit_groups[u] << v
          end

          sum = 0
          unit_groups.each do |unit, values|
            summed = values.reduce(:+)
            sum += summed if unit == 'g'
            sum += summed * 1000 if unit == 'kg'
          end
          localized_sum = (sum.to_f / 1000.0).round(3).to_s.gsub('.', ',')
          
          "#{localized_sum}kg #{entry}"
        end
      end
    end
  end
end

