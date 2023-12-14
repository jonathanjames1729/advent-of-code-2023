# frozen_string_literal: true

require_relative 'base'

class Day01 < Base
  def part1
    data.map do |line|
      digits = line.chars.grep(/\d/)
      "#{digits[0]}#{digits[-1]}".to_i
    end.sum
  end

  def part2
    digit_regexp = /(?:one|two|three|four|five|six|seven|eight|nine|\d)/

    data.map do |line|
      first_digit = name_to_digit(line.match(digit_regexp)[0])
      last_digit = name_to_digit(line.match(digit_regexp, line.rindex(digit_regexp))[0])
      "#{first_digit}#{last_digit}".to_i
    end.sum
  end

  private

  def name_to_digit(digit)
    names_to_digits = {
      one: '1', two: '2', three: '3', four: '4', five: '5',
      six: '6', seven: '7', eight: '8', nine: '9'
    }.freeze
    names_to_digits.fetch(digit.to_sym, digit)
  end
end

ONE = Day01.new
ONE_TEST = Day01.new('test')
