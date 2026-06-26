require 'securerandom'
require './traffic_light'

class Road
  attr_accessor :id, :name, :traffic_light

  def initialize(name, durations)
    @id = SecureRandom.uuid
    @name = name
    @traffic_light = TrafficLight.new(name + " - Light", durations)
  end

  def handle_emergency
    @traffic_light.emergency_green!
  end

  def emergency_stop
    @traffic_light.emergency_red!
  end

  def tick(seconds)
    @traffic_light.tick(seconds)
  end

  def current_color
    puts @traffic_light.current_color
  end
end