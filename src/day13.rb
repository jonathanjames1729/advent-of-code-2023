# frozen_string_literal: true

require_relative 'base'

class Day13 < Base
  def part1
    data.map do |lines|
      vertical = find_vertical_reflection(lines)
      horizontal = find_horizontal_reflection(lines)
      (vertical.nil? ? 0 : 100 * vertical) + (horizontal.nil? ? 0 : horizontal)
    end.sum
  end

  def data
    super.each_with_object([[]]) do |line, result|
      if line.empty?
        result << []
      else
        result[-1] << line
      end
    end
  end

  private

  def transpose(lines)
    lines.map(&:chars).transpose.map(&:join)
  end

  def find_reflection_from_top(lines)
    (1...lines.count).step(2) do |i|
      return (i + 1) / 2 if (0..(i / 2)).all? { |j| lines[j] == lines[i - j] }
    end
    nil
  end

  def find_vertical_reflection(lines)
    axis = find_reflection_from_top(lines)
    return axis unless axis.nil?

    axis = find_reflection_from_top(lines.reverse)
    (lines.count - axis) unless axis.nil?
  end

  def find_horizontal_reflection(lines)
    find_vertical_reflection(transpose(lines))
  end
end

THIRTEEN = Day13.new
THIRTEEN_TEST = Day13.new('test')
