# frozen_string_literal: true

require_relative 'base'

class Day24 < Base
  def part1
    positions = []
    data.combination(2) do |one, two|
      t = time(one, two)
      unless t.nil? || t.negative? || time(two, one).negative?
        positions << [0, 1].map { |i| one.dig(:position, i) + (one.dig(:velocity, i) * t) }
      end
    end
    positions.count { |p| p.all? { |value| value >= 200_000_000_000_000 && value <= 400_000_000_000_000 } }
  end

  def data
    super.map do |line|
      next unless /^\s*(?<position>[,\s0-9]+)\s+@\s+(?<velocity>[-,\s0-9]+)\s*$/ =~ line

      {
        position: position.split.map(&:to_r).freeze,
        velocity: velocity.split.map(&:to_r).freeze
      }
    end
  end

  private

  def time(one, two)
    a = (two.dig(:position, 0) - one.dig(:position, 0)) * two.dig(:velocity, 1)
    b = (two.dig(:position, 1) - one.dig(:position, 1)) * two.dig(:velocity, 0)
    c = one.dig(:velocity, 0) * two.dig(:velocity, 1)
    d = two.dig(:velocity, 0) * one.dig(:velocity, 1)
    c == d ? nil : (a - b) / (c - d)
  end
end

TWENTY_FOUR = Day24.new
TWENTY_FOUR_TEST = Day24.new('test')

# px + vx*t = PX + VX*T
# py + vy*t = PY + VY*T

# px*VY + vx*VY*t = PX*VY + VX*VY*T
# py*VX + VX*vy*t = PY*VX + VX*VY*t

# (vx*VY - VX*vy)*t = PX*VY - PY*VX + py*VX - px*VY
# t = ((PX - px)*VY - (PY -py)*VX) / (vx*VY - VX*vy)