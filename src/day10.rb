# frozen_string_literal: true

require_relative 'base'

class Day10 < Base
  def part1
    data => {start_location:, tiles:}
    start_location => [x, y]
    direction = populate_start(x, y, tiles).first
    path = []
    while path.empty? || (start_location[0] != x) || (start_location[1] != y)
      path << [x, y].freeze
      next_location(x, y, direction, tiles) => [x, y, direction]
    end
    path.count / 2
  end

  TILE_MAP = {
    '|' => %i[north south].freeze,
    '-' => %i[west east].freeze,
    'L' => %i[north east].freeze,
    'J' => %i[north west].freeze,
    '7' => %i[south west].freeze,
    'F' => %i[south east].freeze,
    'S' => nil,
    '.' => nil
  }.freeze

  def data
    result = { start_location: nil, tiles: [] }
    super.each_with_index do |line, y|
      row = []
      line.chars.each_with_index do |tile_char, x|
        result[:start_location] = [x, y].freeze if tile_char == 'S'
        row << TILE_MAP[tile_char]
      end
      result[:tiles] << row
    end
    result
  end

  private

  DIRECTION_TRANSFORM_MAP = {
    north: ->(x, y) { [x, y - 1, :south] },
    south: ->(x, y) { [x, y + 1, :north] },
    west: ->(x, y) { [x - 1, y, :east] },
    east: ->(x, y) { [x + 1, y, :west] }
  }.freeze

  def populate_start(start_x, start_y, tiles)
    start = DIRECTION_TRANSFORM_MAP.filter_map do |direction, transform|
      transform.call(start_x, start_y) => [x, y, reverse_direction]
      if x.negative? || y.negative?
        nil
      else
        tiles[y]&.fetch(x, nil)&.include?(reverse_direction) ? direction : nil
      end
    end
    tiles[start_y][start_x] = start
  end

  def next_location(location_x, location_y, direction, tiles)
    DIRECTION_TRANSFORM_MAP[direction].call(location_x, location_y) => [next_x, next_y, direction_to_exclude]
    [next_x, next_y, tiles[next_y][next_x].find { |d| d != direction_to_exclude }]
  end
end

TEN = Day10.new
