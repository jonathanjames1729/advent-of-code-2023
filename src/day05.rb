# frozen_string_literal: true

require_relative 'base'

class Day05 < Base
  def part1
    data => { seeds:, maps: }
    maps.reduce(seeds) do |memo, map|
      memo.map do |source|
        find_destination(map, source)
      end
    end.min
  end

  def data
    super.each_with_object({ seeds: nil, maps: [] }) do |line, result|
      if /^seeds:\s+(?<seeds>[\s0-9]+)$/ =~ line
        result[:seeds] = seeds.split.map(&:to_i)
      elsif /^(?<source>[a-z]+)-to-(?<destination>[a-z]+) map:$/ =~ line
        result[:maps] << { source:, destination:, definition: [] }
      elsif /^(?<destination_start>[0-9]+)\s+(?<source_start>[0-9]+)\s+(?<length>[0-9]+)$/ =~ line
        result[:maps][-1][:definition] << map_definition(destination_start.to_i, source_start.to_i, length.to_i)
      end
    end
  end

  private

  def map_definition(destination_start, source_start, length)
    {
      source_range: (source_start...(source_start + length)),
      destination_start: destination_start
    }
  end

  def find_destination(map, source)
    map[:definition].each do |line|
      return source - line[:source_range].begin + line[:destination_start] if line[:source_range].include?(source)
    end

    source
  end
end

FIVE = Day05.new
FIVE_TEST = Day05.new('test')
