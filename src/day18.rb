# frozen_string_literal: true

require_relative 'base'

class Day18 < Base
  def initialize(*args)
    super(*args)

    @data_internal = nil
  end

  def part1
    data => {border:, min_x:, max_x:, min_y:, max_y:}
    above = Array.new(max_x - min_x + 1) { |_| { left: false, right: false } }
    (min_y..max_y).reduce(0) do |m, y|
      left = { up: false, down: false }
      (min_x..max_x).reduce(m) do |n, x|
        position = [x, y].freeze
        if border.key?(position)
          border_cube = border[position]
          left = { up: left[:up] ^ border_cube[:up], down: left[:down] ^ border_cube[:down] }
          above[x] = { left: above[x][:left] ^ border_cube[:left], right: above[x][:right] ^ border_cube[:right] }
          n + 1
        else
          left[:up] & left[:down] & above[x][:left] & above[x][:right] ? n + 1 : n
        end
      end
    end
  end

  def data
    @data_internal unless @data_internal.nil?

    border = super.each_with_object(
      { previous: nil, current: [0, 0].freeze, border: Hash.new { |h, k| h[k] = {} } }
    ) do |line, context|
      next unless /^(?<direction_char>[DLRU])\s+(?<length>[1-9][0-9]*)\s+\(#[0-9a-f]{6}\)\s*$/ =~ line

      create_edge(context, direction_char, length.to_i)
    end[:border]
    [0, 0].zip(*border.keys).map(&:minmax) => [[min_x, max_x], [min_y, max_y]]
    @data_internal = { border:, min_x:, max_x:, min_y:, max_y: }
  end

  private

  def initial_border
    Hash.new { |h, k| h[k] = { down: false, left: false, right: false, up: false } }
  end

  DIRECTION_MAP = {
    'D' => { move: ->(x, y) { [x, y + 1].freeze }, forward: :down, reverse: :up },
    'L' => { move: ->(x, y) { [x - 1, y].freeze }, forward: :left, reverse: :right },
    'R' => { move: ->(x, y) { [x + 1, y].freeze }, forward: :right, reverse: :left },
    'U' => { move: ->(x, y) { [x, y - 1].freeze }, forward: :up, reverse: :down }
  }.freeze

  def create_edge(context, direction_char, length)
    context => {previous:, current:, border:}
    direction = DIRECTION_MAP[direction_char]
    length.to_i.times do
      previous = current
      current = direction[:move].call(*previous)
      border[previous][direction[:forward]] = true
      border[current][direction[:reverse]] = true
    end
    context.merge!({ previous:, current: })
  end
end

EIGHTEEN = Day18.new
EIGHTEEN_TEST = Day18.new('test')
