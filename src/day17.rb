# frozen_string_literal: true

require 'pry'
require_relative 'base'

class Day17 < Base
  attr_reader :blocks, :cache, :max_position, :max_run, :min_run, :size, :upper_bound

  def initialize(*args)
    super(*args)

    @blocks = data.map do |line|
      line.chars.map(&:to_i).freeze
    end.freeze
    @size = blocks.count
    @max_position = size - 1
    raise 'Not Square' if blocks.first.count != size
  end

  def part1
    reset(1, 3)
    f([0, 0], 0, nil)
  end

  def part2
    reset(4, 10)
    f([0, 0], 0, nil)
  end

  private

  def calculate_upper_bound
    raise "#{max_position} not divisible by #{min_run}" unless (max_position % min_run).zero?

    steps = max_position / min_run
    @upper_bound = (0...steps).map do |i|
      k = i * min_run
      (1..min_run).map { |j| blocks[k][k + j] + blocks[k + j][k + min_run] }.sum
    end.sum
  end

  def reset(min_run, max_run)
    @min_run = min_run
    @max_run = max_run
    @cache = Array.new(size) { Array.new(size) { { horizontal: nil, vertical: nil } } }
    calculate_upper_bound
  end

  def block(x_position, y_position)
    blocks[y_position][x_position]
  end

  ORIENTATION_MAP = {
    right: :horizontal,
    down: :vertical,
    left: :horizontal,
    up: :vertical
  }

  def update_cache(subtotal, direction, x_position, y_position)
    cache_block = cache[y_position][x_position]
    orientation = ORIENTATION_MAP[direction]
    cached_subtotal = cache_block[orientation]
    return false unless cached_subtotal.nil? || subtotal < cached_subtotal

    cache_block[orientation] = subtotal
    true
  end

  REVERSE_MAP = {
    right: :left,
    down: :up,
    left: :right,
    up: :down
  }.freeze

  MOVE_MAP = {
    right: ->(max_position, x, y) { x == max_position ? nil : [x + 1, y] },
    down: ->(max_position, x, y) { y == max_position ? nil : [x, y + 1] },
    left: ->(_max_position, x, y) { x.zero? ? nil : [x - 1, y] },
    up: ->(_max_position, x, y) { y.zero? ? nil : [x, y - 1] }
  }.freeze

  def f(position, subtotal, direction)
    return upper_bound if subtotal > upper_bound

    if position[0] == max_position && position[1] == max_position
      @upper_bound = subtotal
      return subtotal
    end

    %i[right down left up].filter_map do |next_direction|
      next if next_direction == REVERSE_MAP[direction] || next_direction == direction

      next_position = position
      next_subtotal = subtotal
      move = MOVE_MAP[next_direction]
      (1..max_run).filter_map do |run|
        next if next_position.nil?

        next_position = move.call(max_position, *next_position)
        next if next_position.nil?

        next_subtotal += block(*next_position)
        next unless (run >= min_run) && update_cache(next_subtotal, next_direction, *next_position)

        f(next_position, next_subtotal, next_direction)
      end.min
    end.min
  end
end

SEVENTEEN = Day17.new
SEVENTEEN_TEST = Day17.new('test')
