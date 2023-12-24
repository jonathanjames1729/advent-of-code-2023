# frozen_string_literal: true

require_relative 'base'

class Component
  attr_reader :name, :destinations

  def initialize(name, destinations)
    @name = name
    @destinations = destinations.split(/,\s+/).freeze
  end

  def receive_pulse(pulse, _from, _index, _step)
    destinations.map { |destination| [destination, [pulse, name]] }
  end

  def add_source(source); end

  def reset; end
end

class FlipFlop < Component
  attr_reader :state

  def initialize(*args)
    super(*args)

    @state = :off
  end

  def receive_pulse(pulse, from, index, step)
    return [] if pulse == :high

    if state == :on
      @state = :off
      super(:low, from, index, step)
    else
      @state = :on
      super(:high, from, index, step)
    end
  end

  def reset
    @state = :off
  end
end

class Conjunction < Component
  attr_reader :sources

  def initialize(*args)
    super(*args)

    @sources = {}
  end

  def receive_pulse(pulse, from, index, step)
    if sources[from] != pulse
      sources[from] = pulse
      puts "#{index} (#{step}): #{pulse} #{from} -> #{name}" if name == 'lx'
    end

    if sources.all? { |_source, state| state == :high }
      super(:low, from, index, step)
    else
      super(:high, from, index, step)
    end
  end

  def add_source(source)
    sources[source] = :low
  end

  def reset
    sources.each_key { |name| sources[name] = :low }
  end
end

class Receiver < Component
  def initialize(*args)
    super(*args)

    @received = false
  end

  def receive_pulse(pulse, from, index, step)
    @received = true if pulse == :low

    super(pulse, from, index, step)
  end

  def reset
    @received = false
  end

  def received?
    @received
  end
end

class Day20 < Base
  def initialize(*args)
    super(*args)

    @receiver = nil
    @data_internal = nil
  end

  def part1
    reset
    counts = { low: 0, high: 0 }
    (1..1000).each do |i|
      press_button(i, counts)
    end
    counts => {low:, high:}
    low * high
  end

  def part2
    reset
    (1..20_000).each do |i|
      press_button(i)
    end
  end

  # The receiver rx is connected to a conjunction lx which outputs when it receives a pulse.
  # Running TWENTY.part2 gives the following output:
  #   3733 (5): high cl -> lx
  #   3733 (7): low cl -> lx
  #   3911 (5): high lb -> lx
  #   3911 (7): low lb -> lx
  #   4091 (5): high rp -> lx
  #   4091 (7): low rp -> lx
  #   4093 (5): high nj -> lx
  #   4093 (7): low nj -> lx
  #   7466 (5): high cl -> lx
  #   7466 (7): low cl -> lx
  #   7822 (5): high lb -> lx
  #   7822 (7): low lb -> lx
  #   8182 (5): high rp -> lx
  #   8182 (7): low rp -> lx
  #   8186 (5): high nj -> lx
  #   8186 (7): low nj -> lx
  #   11199 (5): high cl -> lx
  #   11199 (7): low cl -> lx
  #   11733 (5): high lb -> lx
  #   11733 (7): low lb -> lx
  #   12273 (5): high rp -> lx
  #   12273 (7): low rp -> lx
  #   12279 (5): high nj -> lx
  #   12279 (7): low nj -> lx
  #   14932 (5): high cl -> lx
  #   14932 (7): low cl -> lx
  #   15644 (5): high lb -> lx
  #   15644 (7): low lb -> lx
  #   16364 (5): high rp -> lx
  #   16364 (7): low rp -> lx
  #   16372 (5): high nj -> lx
  #   16372 (7): low nj -> lx
  #   18665 (5): high cl -> lx
  #   18665 (7): low cl -> lx
  #   19555 (5): high lb -> lx
  #   19555 (7): low lb -> lx
  # This shows that the four inputs to lx receive a pulse according to cycles of different lengths.
  # At the end of the cycle, the input receives a high pulse 5 pulses after the button was pressed
  # and a low pulse 2 pules after that.
  # cl has a cycle of 3773 button presses, lb has a cycle of 3911 button presses, rp has a cycle of
  # 4091 button presses and nj has a cycle of 4093 button presses.
  # So the first time these cycles align is after 3773*3911*4091*4093 = 244465191362269 button
  # presses. 3911, 4091 and 4093 are prime and 3773 = 7^3 * 11 so they are all coprime hence the
  # least common multiple of the numbers is their product.

  def data
    return @data_internal unless @data_internal.nil?

    @data_internal = super.each_with_object({}) do |line, result|
      create_module(result, line)
    end
    @data_internal['button'] = Component.new('button', 'broadcaster')
    process_sources
    @data_internal
  end

  def receiver
    @receiver ||= data.find { |_, component| component.respond_to?(:received?) }.last
  end

  private

  def reset
    data.each_value(&:reset)
  end

  def create_module(result, line)
    unless /^(?:broadcaster|%(?<flip_flop>[a-z]+)|&(?<conjunction>[a-z]+))\s+->\s+(?<dests>[\s,a-z]+)\s*$/ =~ line
      return
    end

    mod = if flip_flop.nil?
            conjunction.nil? ? Component.new('broadcaster', dests) : Conjunction.new(conjunction, dests)
          else
            FlipFlop.new(flip_flop, dests)
          end
    result[mod.name] = mod
  end

  def process_sources
    missing = @data_internal.each_with_object([]) do |(name, component), result|
      component.destinations.each do |destination|
        if @data_internal.include?(destination)
          @data_internal[destination].add_source(name)
        else
          result.append(destination)
        end
      end
    end
    missing.each { |name| @data_internal[name] = Receiver.new(name, '') }
  end

  def press_button(index, counts = nil)
    pulses = data['button'].receive_pulse(:low, nil, index, 0)
    (1..).each do |step|
      pulses = pulses.each_with_object([]) do |(destination, args), result|
        counts[args.first] += 1 unless counts.nil?
        result.concat(data[destination].receive_pulse(*args, index, step)) if data.include?(destination)
      end
      break if pulses.empty?
    end
  end
end

TWENTY = Day20.new
TWENTY_TEST = Day20.new('test')
