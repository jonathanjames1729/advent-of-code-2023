# frozen_string_literal: true

class Base
  attr_reader :data

  def initialize
    data_filename = "data/#{self.class.name.downcase}.txt"
    File.open(data_filename, 'r') do |file|
      @data = file.readlines(chomp: true)
    end
  end
end
