# frozen_string_literal: true

Dir.new(__dir__).each_child do |path|
  if /(?<name>day[0-2][0-9]).rb/ =~ path
    require_relative name
  end
end
