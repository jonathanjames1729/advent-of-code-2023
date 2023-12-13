# frozen_string_literal: true

require_relative 'base'

class Day12 < Base
  def part1
    data.map do |springs|
      springs => {pattern:, groups:}
      find_arrangements(pattern, groups)
    end.sum
  end

  SPRING_MAP = {
    '.' => :operational,
    '#' => :damaged,
    '?' => :unknown
  }.freeze

  def data
    super.map do |line|
      next unless /^(?<pattern>[.#?]+)\s+(?<groups>[0-9,]+)$/ =~ line

      {
        pattern: pattern.chars.map { |spring| SPRING_MAP[spring] }.freeze,
        groups: groups.split(',').map(&:to_i).freeze
      }
    end
  end

  private

  def find_unknowns(pattern)
    unknowns = []
    pattern.each_with_index { |spring, index| unknowns << index if spring == :unknown }
    unknowns
  end

  def find_groups(pattern)
    pattern.each_with_object({ groups: [], in_group: false }) do |spring, context|
      if spring == :damaged
        if context[:in_group]
          context[:groups][-1] += 1
        else
          context[:in_group] = true
          context[:groups].append(1)
        end
      else
        context[:in_group] = false
      end
    end[:groups]
  end

  def find_arrangements(pattern, groups)
    count = 0
    unknowns = find_unknowns(pattern)
    damaged_missing = groups.sum - pattern.count(:damaged)
    unknowns.combination(damaged_missing) do |damaged|
      fixed_pattern = unknowns.each_with_object(Array.new(pattern)) do |index, result|
        result[index] = damaged.include?(index) ? :damaged : :operational
      end
      count += 1 if find_groups(fixed_pattern) == groups
    end
    count
  end
end

TWELVE = Day12.new
TWELVE_TEST = Day12.new('test')
