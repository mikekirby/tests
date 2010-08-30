#!/usr/bin/ruby

require "rubygems"
require "logger"
require "UPnP/SSDP"

#log = Logger.new(STDOUT)
#log.level = Logger::DEBUG
#puts Socket.constants.sort

resources = UPnP::SSDP.new.search :root
locations = resources.map { |resource| resource.location }
puts locations.join("\n")

