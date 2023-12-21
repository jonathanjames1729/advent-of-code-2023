# frozen_string_literal: true

require_relative 'base'

class Day19 < Base
  def part1
    data => {workflows:, parts:}
    parts.filter_map do |part|
      part_accepted?(workflows, part) ? part.values.sum : nil
    end.sum
  end

  def part2
    workflows = data[:workflows]
    f(workflows, :in, { x: (1..4000), m: (1..4000), a: (1..4000), s: (1..4000) })
  end

  def data
    super.each_with_object({ workflows: {}, parts: [] }) do |line, result|
      if /^(?<label>[a-z]+){(?<steps>[^}]+)}$/ =~ line
        result[:workflows][label.to_sym] = steps.split(',').map do |step|
          process_step(step)
        end
      elsif /^{x=(?<x>[1-9][0-9]*),m=(?<m>[1-9][0-9]*),a=(?<a>[1-9][0-9]*),s=(?<s>[1-9][0-9]*)}$/ =~ line
        result[:parts] << { x:, m:, a:, s: }.transform_values(&:to_i)
      end
    end
  end

  private

  def process_step(step)
    if /(?<rating>[amsx])(?<compare>[<>])(?<value>[1-9][0-9]*):(?<destination>[AR]|[a-z]+)/ =~ step
      { rating: rating.to_sym, compare: compare.to_sym, value: value.to_i, destination: destination.to_sym }
    else
      { destination: step.to_sym }
    end
  end

  def part_accepted?(workflows, part)
    label = :in
    until %i[A R].include?(label)
      workflows[label].each do |step|
        if step[:rating].nil? || part[step[:rating]].send(step[:compare], step[:value])
          label = step[:destination]
          break
        end
      end
    end
    label == :A
  end

  def f(workflows, label, part_ranges)
    return 0 if label == :R
    return part_ranges.reduce(1) { |memo, (_, range)| memo * range.count } if label == :A

    workflows[label].reduce([0, false]) do |(memo, skip), step|
      next [memo, true] if skip

      if step[:rating].nil?
        [memo + f(workflows, step[:destination], part_ranges), true]
      else
        step => {rating:, compare:, value:, destination:}
        range = part_ranges[rating]
        if compare == :<
          if value <= range.min
            [memo, false]
          elsif range.max < value
            [memo + f(workflows, destination, part_ranges), true]
          else
            part_ranges[rating] = (value..range.max)
            [memo + f(workflows, destination, part_ranges.merge({ rating => (range.min...value) })), false]
          end
        elsif value < range.min
          [memo + f(workflows, destination, part_ranges), true]
        elsif range.max <= value
          [memo, false]
        else
          part_ranges[rating] = (range.min..value)
          [memo + f(workflows, destination, part_ranges.merge({ rating => ((value + 1)..range.max) })), false]
        end
      end
    end.first
  end
end

NINETEEN = Day19.new
NINETEEN_TEST = Day19.new('test')