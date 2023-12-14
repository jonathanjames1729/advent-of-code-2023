# frozen_string_literal: true

require_relative 'base'

class Day09 < Base
  def part1
    data.map do |line|
      stack = [line.last]
      until line.all?(&:zero?)
        line = differences(line)
        stack << line.last
      end
      stack.sum
    end.sum
  end

  def part2
    data.map do |line|
      stack = [line.first]
      until line.all?(&:zero?)
        line = differences(line)
        stack << line.first
      end
      stack.reverse.reduce { |memo, element| element - memo }
    end.sum
  end

  def data
    super.map do |line|
      line.split.map(&:to_i)
    end
  end

  private

  def differences(numbers)
    result = []
    numbers.each_cons(2) do |one, two|
      result << (two - one)
    end
    result
  end
end

NINE = Day09.new
NINE_TEST = Day09.new('test')
