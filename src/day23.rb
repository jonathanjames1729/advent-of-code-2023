# frozen_string_literal: true

require 'pry'
require_relative 'base'

class Day23 < Base
  def initialize(*args)
    super(*args)

    @data_internal = nil
    @finish = nil
    @start = nil
  end

  def part1
    f(Set.new, start)
  end

  TILE_MAP = {
    '.' => :path,
    '#' => :forest,
    '>' => :east,
    'v' => :south,
    '<' => :west,
    '^' => :north
  }.freeze

  def data
    return @data_internal unless @data_internal.nil?

    @data_internal = super.map do |line|
      line.chars.map do |tile|
        TILE_MAP[tile]
      end
    end
  end

  private

  def finish
    @finish ||= [data.last.find_index(:path), height - 1].freeze
  end

  def start
    @start ||= [data.first.find_index(:path), 0].freeze
  end

  def tile_contents(x_location, y_location)
    data[y_location][x_location]
  end

  DIRECTION_MAP = {
    east: ->(x, y) { [x + 1, y].freeze },
    south: ->(x, y) { [x, y + 1].freeze },
    west: ->(x, y) { [x - 1, y].freeze },
    north: ->(x, y) { [x, y - 1].freeze }
  }.freeze

  def f(path, location)
    return 0 if path.include?(location)
    return path.size if location == finish

    tile = tile_contents(*location)
    return 0 if tile == :forest

    new_path = path | [location]
    if DIRECTION_MAP.include?(tile)
      f(new_path, DIRECTION_MAP[tile].call(*location))
    else
      DIRECTION_MAP.map { |_, direction| f(new_path, direction.call(*location)) }.max
    end
  end
end

TWENTY_THREE = Day23.new
TWENTY_THREE_TEST = Day23.new('test')
