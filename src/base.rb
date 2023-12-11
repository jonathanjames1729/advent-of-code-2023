# frozen_string_literal: true

class Base
  attr_reader :data

  def initialize(name = 'data')
    data_filename = "#{name}/#{self.class.name.downcase}.txt"
    File.open(data_filename, 'r') do |file|
      @data = file.readlines(chomp: true)
    end
  end
end
