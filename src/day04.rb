# frozen_string_literal: true

require_relative 'base'

class Day04 < Base
  def part1
    data.map do |card|
      wins = number_of_wins(card)
      if wins.zero?
        0
      else
        2.pow(wins - 1)
      end
    end.sum
  end

  def part2
    cards = data.map { |card| { count: 1, wins: number_of_wins(card) } }

    i = 0
    cards.map do |card|
      (i + 1).upto(i + card[:wins]) do |j|
        break unless j < cards.count

        cards[j][:count] += card[:count]
      end
      i += 1

      card[:count]
    end.sum
  end

  def data
    regex = /^Card\s+(?<index>[1-9][0-9]*):\s+(?<winning>[0-9][\s0-9]*[0-9])\s+\|\s+(?<ours>[0-9][\s0-9]*[0-9])\s*$/
    super.map do |line|
      next unless (match = regex.match(line))

      {
        index: match['index'],
        winning_numbers: match['winning'].split.map(&:to_i),
        our_numbers: match['ours'].split.map(&:to_i)
      }
    end
  end

  private

  def number_of_wins(card)
    card[:our_numbers].intersection(card[:winning_numbers]).count
  end
end

FOUR = Day04.new
FOUR_TEST = Day04.new('test')
