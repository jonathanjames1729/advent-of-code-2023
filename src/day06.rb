# frozen_string_literal: true

require_relative 'base'

class Day06 < Base
  def part1
    data1.map do |race|
      race => { time:, distance: }
      (0..time).count { |charge_time| distance_given_charge_time(time, charge_time) > distance }
    end.reduce(&:*)
  end

  def part2
    data2 => { time:, distance: }
    smallest_winning_time = (0..(time / 2)).bsearch do |attempt|
      distance_given_charge_time(time, attempt) > distance
    end

    time + 1 - (2 * smallest_winning_time)
  end

  def data1
    table = data.reduce([]) do |memo, line|
      if /^(?<field>[A-Z][a-z]+):\s+(?<entries>[\s0-9]*)\s*$/ =~ line
        memo << entries.split.map { |value| { field.downcase.to_sym => value.to_i } }
      end
    end
    row = table.shift
    row.zip(*table).map do |column|
      top = column.shift
      top.merge(*column)
    end
  end

  def data2
    data.reduce({}) do |memo, line|
      if /^(?<field>[A-Z][a-z]+):\s+(?<entries>[\s0-9]*)\s*$/ =~ line
        memo.merge({ field.downcase.to_sym => entries.split.join.to_i })
      end
    end
  end

  private

  def distance_given_charge_time(time, charge_time)
    charge_time * (time - charge_time)
  end
end

SIX = Day06.new
