# frozen_string_literal: true

require_relative 'base'

class Day02 < Base
  def part1
    bag = { red: 12, green: 13, blue: 14 }.freeze
    data.filter_map do |game|
      game[:game] if game[:turns].all? do |turn|
        turn.all? do |colour, quantity|
          quantity <= bag[colour]
        end
      end
    end.sum
  end

  def part2
    data.map do |game|
      smallest_bag = { red: 0, green: 0, blue: 0 }.merge(*game[:turns]) do |_colour, old_quantity, new_quantity|
        [new_quantity, old_quantity].max
      end
      smallest_bag[:red] * smallest_bag[:green] * smallest_bag[:blue]
    end.sum
  end

  def data
    super.map do |line|
      match = /^Game ([1-9][0-9]*): (.*)$/.match(line)
      {
        game: match[1].to_i,
        turns: match[2].split('; ').map do |turn_line|
          turn_line.split(', ').each_with_object({}) do |colour_line, turn|
            colour_match = /([1-9][0-9]*) (red|green|blue)/.match(colour_line)
            turn[colour_match[2].to_sym] = colour_match[1].to_i
          end
        end
      }
    end
  end
end

TWO = Day02.new
