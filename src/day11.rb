# frozen_string_literal: true

require_relative 'base'

class Day11 < Base
  def part1
    part(2)
  end

  def part2
    part(1_000_000)
  end

  def data
    result = { galaxies: [], column_empty: [], row_empty: [] }
    super.each_with_index do |line, y|
      line.chars.each_with_index do |item, x|
        next unless item == '#'

        result[:galaxies] << [x, y].freeze
        result[:column_empty][x] = false
        result[:row_empty][y] = false
      end
    end
    result
  end

  private

  def distance(one, two, empty, expansion)
    (two > one ? (one...two) : (two...one)).map { |i| empty[i].nil? ? expansion : 1 }.sum
  end

  def part(expansion)
    data => {galaxies:, column_empty:, row_empty:}
    result = 0
    galaxies.combination(2) do |one, two|
      result += distance(one.first, two.first, column_empty, expansion)
      result += distance(one.last, two.last, row_empty, expansion)
    end
    result
  end
end

ELEVEN = Day11.new
ELEVEN_TEST = Day11.new('test')
