# frozen_string_literal: true

require_relative 'base'

class Day21 < Base
  def initialize(*args)
    super(*args)

    @data_internal = nil
    @height = nil
    @weight = nil
    @x_max = nil
    @y_max = nil
  end

  def part1
    (1..64).reduce(Set.new([find_start])) do |memo, _|
      memo.each_with_object(Set.new) do |point, result|
        adjacent_points(*point, true).each do |adjacent_point|
          adjacent_point => [x, y]
          result.add(adjacent_point) if data[y][x] != :rock
        end
      end
    end.count
  end

  PLOT_MAP = {
    '.' => :garden,
    '#' => :rock,
    'S' => :start
  }.freeze

  def data
    return @data_internal unless @data_internal.nil?

    @data_internal = super.map do |line|
      line.chars.map do |plot|
        PLOT_MAP[plot]
      end
    end
  end

  private

  def height
    @height ||= data.count
  end

  def width
    @width ||= data.first.count
  end

  def x_max
    @x_max ||= width - 1
  end

  def y_max
    @y_max ||= height - 1
  end

  def find_start
    data.each_with_index do |line, y|
      x = line.find_index(:start)
      return [x, y].freeze unless x.nil?
    end
  end

  def add_point(result, x_location, y_location)
    result << [x_location, y_location].freeze
  end

  def add_horizontal_points(result, x_location, y_location, finite)
    add_point(result, x_location - 1, y_location) unless finite && x_location.zero?
    add_point(result, x_location + 1, y_location) unless finite && x_location == x_max
  end

  def add_vertical_points(result, x_location, y_location, finite)
    add_point(result, x_location, y_location - 1) unless finite && y_location.zero?
    add_point(result, x_location, y_location + 1) unless finite && y_location == y_max
  end

  def adjacent_points(x_location, y_location, finite)
    result = []
    add_horizontal_points(result, x_location, y_location, finite)
    add_vertical_points(result, x_location, y_location, finite)
  end
end

TWENTY_ONE = Day21.new
TWENTY_ONE_TEST = Day21.new('test')
