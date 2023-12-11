# frozen_string_literal: true

require_relative 'base'

class Day10 < Base
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

  def part1
    data => {tiles:, start: [start_x, start_y]}
    find_loop(start_x, start_y, tiles).count / 2
  end

  def part2
    data => {tiles:, start: [start_x, start_y]}
    loop_path = find_loop(start_x, start_y, tiles)
    north = [[]] * tiles.first.count
    count = 0
    tiles.each_with_index do |row, y|
      west = []
      row.each_with_index do |tile, x|
        if loop_path.include?([x, y])
          north[x] = symmetric_difference(north[x], tile, TILE_MAP['-'])
          west = symmetric_difference(west, tile, TILE_MAP['|'])
        else
          count += north[x].empty? || west.empty? ? 0 : 1
        end
      end
    end
    count
  end

  def data
    result = { tiles: [], start: nil }
    super.each_with_index do |line, y|
      row = []
      line.chars.each_with_index do |tile_char, x|
        result[:start] = [x, y].freeze if tile_char == 'S'
        row << TILE_MAP[tile_char]
      end
      result[:tiles] << row
    end
    result
  end

  private

  def find_loop(start_x, start_y, tiles)
    direction = populate_start(start_x, start_y, tiles).first
    x = start_x
    y = start_y
    path = []
    while path.empty? || (x != start_x) || (y != start_y)
      path << [x, y].freeze
      next_location(x, y, direction, tiles) => [x, y, direction]
    end
    path
  end

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

  def symmetric_difference(current, tile, mask)
    masked = tile.intersection(mask)
    current.union(masked).difference(current.intersection(masked))
  end
end

TEN = Day10.new
