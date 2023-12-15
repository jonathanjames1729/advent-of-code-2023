# frozen_string_literal: true

require_relative 'base'

class Day14 < Base
  def part1
    rows = tilt_north(data)
    load_north(rows)
  end

  def part2
    rows = data
    loads = []
    configurations = []
    1_000_000_000.times do |index|
      rows = cycle(rows)
      load = load_north(rows)
      loads_length = loads.count
      matches = (0...loads.count).filter { |i| loads[i] == load }
      (1..).each do |i|
        break unless matches.count >= (2 * i)

        one = loads.slice(matches[-i]...loads_length)
        two = loads.slice(matches[-(2 * i)]...matches[-i])
        return one[(999_999_999 - index) % one.count] if one == two && configurations[-i] == rows
      end
      loads << load
      configurations << rows
    end
    loads[-1]
  end

  ROCK_MAP = {
    'O' => :round,
    '#' => :cube
  }.freeze

  def data
    super.map do |row|
      row.chars.map do |space|
        ROCK_MAP[space]
      end
    end
  end

  private

  def tilt_north(rows)
    result = []
    stop = Array.new(rows.first.count, 0)
    rows.each_with_index do |row, y|
      result_row = []
      result << result_row
      row.each_with_index do |space, x|
        if space == :round
          result_row << nil
          result[stop[x]][x] = :round
          stop[x] += 1
        else
          stop[x] = y + 1 if space == :cube
          result_row << space
        end
      end
    end
    result
  end

  def tilt_south(rows)
    tilt_north(rows.reverse).reverse
  end

  def tilt_row_west(row)
    result_row = []
    stop = 0
    row.each_with_index do |space, x|
      if space == :round
        result_row << nil
        result_row[stop] = :round
        stop += 1
      else
        stop = x + 1 if space == :cube
        result_row << space
      end
    end
    result_row
  end

  def tilt_west(rows)
    rows.map do |row|
      tilt_row_west(row)
    end
  end

  def tilt_east(rows)
    rows.map do |row|
      tilt_row_west(row.reverse).reverse
    end
  end

  def cycle(rows)
    tilt_east(tilt_south(tilt_west(tilt_north(rows))))
  end

  def load_north(rows)
    result = 0
    height = rows.count
    rows.each_with_index do |row, y|
      result += (height - y) * row.count { |space| space == :round }
    end
    result
  end
end

FOURTEEN = Day14.new
FOURTEEN_TEST = Day14.new('test')
