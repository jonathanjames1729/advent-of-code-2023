# frozen_string_literal: true

require_relative 'base'

class Day08 < Base
  def part1
    data => {nodes:, instructions:}
    part(nodes, instructions, [nodes['AAA']], ['ZZZ'], 0)
  end

  def data
    super.each_with_object({ nodes: {} }) do |line, result|
      if /^[LR]+$/ =~ line
        result[:instructions] = line.chars.map { |char| char == 'L' ? :left : :right }
      elsif /^\s*(?<label>[A-Z0-9]{3})\s+=\s+\((?<left>[A-Z0-9]{3}),\s+(?<right>[A-Z0-9]{3})\)\s*$/ =~ line
        result[:nodes][label] = { label:, left:, right: }
      end
    end
  end

  private

  def part(nodes, instructions, starting_nodes, ending_labels, min_index)
    current_nodes = starting_nodes
    length = instructions.count
    (0..).each do |index|
      return index if (index >= min_index) && current_nodes.all? { |node| ending_labels.include?(node[:label]) }

      instruction = instructions[index % length]
      current_nodes = current_nodes.map { |node| nodes[node[instruction]] }
    end
  end
end

EIGHT = Day08.new
EIGHT_TEST = Day08.new('test')
