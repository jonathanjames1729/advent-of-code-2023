# frozen_string_literal: true

require_relative 'base'

class Day03 < Base
  def part1
    data => {symbols:, numbers:}
    symbol_locations = symbols.each_with_object(Set.new) { |symbol, locations| locations.add([symbol[:x], symbol[:y]]) }
    numbers.filter_map do |number|
      number[:number] if adjacent_locations(number[:x_range], number[:y]).intersect?(symbol_locations)
    end.sum
  end

  def part2
    data => {symbols:, numbers:}
    symbols.filter_map do |symbol|
      next unless symbol[:symbol] == '*'

      symbol => {x:, y:}
      adjacent_locations = adjacent_locations((x..x), y)
      adjacent_numbers = numbers.filter_map do |number|
        number[:number] if adjacent_locations.intersect?(number[:x_range].map { |x| [x, number[:y]] })
      end
      adjacent_numbers.count == 2 ? adjacent_numbers.reduce(:*) : nil
    end.sum
  end

  def data
    y = 0
    super.each_with_object({ symbols: [], numbers: [] }) do |line, result|
      extract_from_line(result, line, y)
      y += 1
    end
  end

  private

  def extract_from_line(result, line, y_position)
    x = 0
    while (match = /(?:([1-9][0-9]*)|[^.0-9])/.match(line, x))
      if match[1].nil?
        result[:symbols].push({ symbol: match[0], x: match.begin(0), y: y_position})
      else
        result[:numbers].push({ number: match[1].to_i, x_range: (match.begin(1)...match.end(1)), y: y_position })
      end
      x = match.end(0)
    end
  end

  def adjacent_locations(x_range, y_position)
    expanded_x_range = Range.new(x_range.begin - 1, x_range.end + 1, x_range.exclude_end?)
    ends = Set[[expanded_x_range.min, y_position], [expanded_x_range.max, y_position]]
    expanded_x_range.reduce(ends) do |locations, x|
      locations | [[x, y_position - 1], [x, y_position + 1]]
    end
  end
end

THREE = Day03.new
THREE_TEST = Day03.new('test')
