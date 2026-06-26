require 'securerandom'
require './signal'

class TrafficLight
  attr_accessor :id, :name, :signal  
  def initialize(name, durations)
    @id = SecureRandom.uuid
    @signal = TrafficSignal.new(durations)
  end

  def emergency_green!
    @signal.emergency_green!
  end

  def emergency_red!
    @signal.emergency_green!
  end

  def tick(seconds=1)
    seconds.times { @signal.tick }
  end  

  def current_color
    @signal.current_color
  end
end