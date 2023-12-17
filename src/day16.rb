# frozen_string_literal: true

require_relative 'base'

class Day16 < Base
  def part1
    shine_beam([-1, 0], [1, 0])
  end

  def part2
    tiles = data
    height = tiles.count - 1
    width = tiles.first.count - 1
    energized = []
    (0...height).each { |y| energized.push(shine_beam([-1, y], [1, 0]), shine_beam([width, y], [-1, 0])) }
    (0...width).each { |x| energized.push(shine_beam([x, -1], [0, 1]), shine_beam([x, height], [0, -1])) }
    energized.max
  end

  TILE_MAP = {
    '.' => ->(x, y) { [[x, y]] },
    '\\' => ->(x, y) { [[y, x]] },
    '/' => ->(x, y) { [[-y, -x]] },
    '|' => ->(x, y) { y.zero? ? [[0, -1], [0, 1]] : [[x, y]] },
    '-' => ->(x, y) { x.zero? ? [[-1, 0], [1, 0]] : [[x, y]] }
  }.freeze

  def data
    super.map do |line|
      line.chars.map do |tile|
        { transform: TILE_MAP[tile], energized: Set.new }
      end.append(nil)
    end.append([])
  end

  private

  def move(beam, tiles)
    beam => {location: [location_x, location_y], direction: [direction_x, direction_y]}
    location_x += direction_x
    location_y += direction_y
    tile = tiles[location_y][location_x]
    return nil if tile.nil? || tile[:energized].add?([direction_x, direction_y].freeze).nil?

    tile[:transform].call(direction_x, direction_y).map { |d| { location: [location_x, location_y], direction: d } }
  end

  def energized?(tile)
    return false if tile.nil?

    !tile[:energized].empty?
  end

  def shine_beam(location, direction)
    tiles = data
    beams = [{ location:, direction: }]
    until beams.empty?
      beams = beams.filter_map do |beam|
        move(beam, tiles)
      end.flatten
    end
    tiles.sum { |line| line.count { |tile| energized?(tile) } }
  end
end

SIXTEEN = Day16.new
SIXTEEN_TEST = Day16.new('test')
