# frozen_string_literal: true

require_relative 'base'

class Day15 < Base
  def part1
    data.map do |step|
      hash_algorithm_value(step)
    end.sum
  end

  def part2
    hashmap_algorithm.reduce([0, 1]) do |(subtotal, box_index), box|
      [
        box.reduce([0, 1]) do |(box_subtotal, lens_index), lens|
          [box_subtotal + (box_index * lens_index * lens[:length]), lens_index + 1]
        end.first + subtotal,
        box_index + 1
      ]
    end.first
  end

  def data
    super.first.split(',')
  end

  private

  def hash_algorithm_value(label)
    label.chars.reduce(0) do |subtotal, char|
      ((subtotal + char.ord) * 17) % 256
    end
  end

  def perform_operation(box, operation, label, length)
    if operation == '='
      lens = box.find { |l| l[:label] == label }
      if lens.nil?
        box.append({ label:, length: })
      else
        lens[:length] = length
      end
    elsif operation == '-'
      box.delete_if { |lens| lens[:label] == label }
    end
  end

  def hashmap_algorithm
    data.each_with_object(Array.new(256) { [] }) do |step, boxes|
      next unless /^(?<label>[a-z]+)(?<operation>[-=])(?<length>[1-9]?)$/ =~ step

      box = boxes[hash_algorithm_value(label)]
      perform_operation(box, operation, label, length&.to_i)
    end
  end
end

FIFTEEN = Day15.new
FIFTEEN_TEST = Day15.new('test')
