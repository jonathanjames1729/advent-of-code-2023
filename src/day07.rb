# frozen_string_literal: true

require_relative 'base'

class Hand
  HAND_STRENGTH = { '11111' => 1, '1112' => 2, '122' => 3, '113' => 4, '23' => 5, '14' => 6, '5' => 7 }.freeze
  CARD_STRENGTH = { 'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10 }.freeze

  attr_reader :cards, :strength, :bid

  def initialize(hand, bid)
    card_chars = hand.chars
    @cards = card_chars.map { |card| card_strength(card) }
    @strength = hand_strength(card_chars)
    @bid = bid.to_i
  end

  def <=>(other)
    result = strength <=> other.strength
    return result unless result.zero?

    cards <=> other.cards
  end

  protected

  def card_strength(card)
    CARD_STRENGTH.fetch(card, card.to_i)
  end

  def hand_strength(cards)
    classifier = cards.each_with_object(Hash.new(0)) do |card, result|
      result[card] += 1
    end.map(&:last).sort.map(&:to_s).join
    HAND_STRENGTH[classifier]
  end
end

class HandWithJoker < Hand
  private

  def card_strength(card)
    return 1 if card == 'J'

    super
  end

  def hand_strength(cards)
    strength = super(cards)
    return strength unless cards.include?('J')

    cards.uniq.map do |substitute|
      if substitute == 'J'
        strength
      else
        super(cards.map { |card| card == 'J' ? substitute : card })
      end
    end.max
  end
end

class Day07 < Base
  def part1
    part(Hand)
  end

  def part2
    part(HandWithJoker)
  end

  private

  def hands(klass)
    data.map do |line|
      if /^(?<hand>[2-9AJKQT]{5})\s+(?<bid>[1-9][0-9]*)\s*$/ =~ line
        klass.new(hand, bid)
      end
    end
  end

  def part(klass)
    result = 0
    hands(klass).sort.each_with_index { |hand, index| result += hand.bid * (index + 1) }
    result
  end
end

SEVEN = Day07.new
