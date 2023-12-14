# frozen_string_literal: true

require_relative 'base'

class Day13 < Base
  def part1
    data.map do |lines|
      vertical = find_vertical_reflection(lines) { |l| find_reflection_from_top(l) }
      horizontal = find_horizontal_reflection(lines) { |l| find_reflection_from_top(l) }
      (vertical.nil? ? 0 : 100 * vertical) + (horizontal.nil? ? 0 : horizontal)
    end.sum
  end

  def part2
    data.map do |lines|
      vertical = find_vertical_reflection(lines) { |l| find_reflection_with_smudge_from_top(l) }
      horizontal = find_horizontal_reflection(lines) { |l| find_reflection_with_smudge_from_top(l) }
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

  def measure_string_difference(one, two)
    (0...one.length).count { |i| one[i] != two[i] }
  end

  def find_reflection_with_smudge_from_top(lines)
    (1...lines.count).step(2) do |i|
      differences = (0..(i / 2)).filter { |j| lines[j] != lines[i - j] }
      next unless differences.count == 1

      j = differences.first
      return (i + 1) / 2 if measure_string_difference(lines[j], lines[i - j]) == 1
    end
    nil
  end

  def find_vertical_reflection(lines, &blk)
    axis = blk.call(lines)
    return axis unless axis.nil?

    axis = blk.call(lines.reverse)
    (lines.count - axis) unless axis.nil?
  end

  def find_horizontal_reflection(lines, &)
    find_vertical_reflection(transpose(lines), &)
  end
end

THIRTEEN = Day13.new
THIRTEEN_TEST = Day13.new('test')
