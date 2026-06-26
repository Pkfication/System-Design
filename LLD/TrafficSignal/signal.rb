class State
  def turn_red; raise NotImplementedError; end
  def turn_green; raise NotImplementedError; end
  def turn_yellow; raise NotImplementedError; end
  def tick; raise NotImplementedError; end
  def current_color; raise NotImplementedError; end
end

class RedState < State
  def initialize(signal)
    @signal = signal
  end

  def turn_green
    @signal.time_in_state = 0
    @signal.set_state(@signal.green_state)
  end  

  def turn_red
    puts "Already on RED state"
  end  

  def turn_yellow
    puts "Invalid Signal"
  end  

  def tick(seconds=1)
    puts "TICK: #{@signal.time_in_state} -> #{current_color}"
    turn_green and return if @signal.time_in_state >= @signal.durations[:red]
  
    @signal.time_in_state += 1
  end

  def current_color
    "RED"
  end
end

class GreenState < State
  def initialize(signal)
    @signal = signal
  end

  def turn_green
    puts "Already on Green state"
  end  

  def turn_red
    # Emergency State
    @signal.time_in_state = 0
    @signal.set_state(@signal.red_state)
  end  

  def turn_yellow
    @signal.time_in_state = 0
    @signal.set_state(@signal.yellow_state)
  end  

  def tick(seconds=1)
    puts "TICK: #{@signal.time_in_state} -> #{current_color}"
    turn_yellow and return if @signal.time_in_state >= @signal.durations[:green]
  
    @signal.time_in_state += 1
  end

  def current_color
    "GREEN"
  end
end

class YellowState < State
  def initialize(signal)
    @signal = signal
  end

  def turn_green
    @signal.time_in_state = 0
    @signal.set_state(@signal.green_state)
  end  

  def turn_red
    # Emergency State
    @signal.time_in_state = 0
    @signal.set_state(@signal.red_state)
  end  

  def turn_yellow
    puts "Already on Yellow state"
  end  

  def tick
    puts "TICK: #{@signal.time_in_state} -> #{current_color}"
    turn_red and return if @signal.time_in_state >= @signal.durations[:yellow]
  
    @signal.time_in_state += 1
  end

  def current_color
    "YELLOW"
  end
end

class TrafficSignal
  attr_accessor :id, :durations, :time_in_state, :current_state
  attr_reader   :red_state, :green_state, :yellow_state

  def initialize(durations)
    @id = SecureRandom.uuid
    @durations = {
      red: durations[:red] || 90,
      green: durations[:green] || 30,
      yellow: durations[:yellow] || 5
    }
    @time_in_state = 0
    @current_state = nil

    @red_state = RedState.new(self)
    @green_state = GreenState.new(self)
    @yellow_state = YellowState.new(self)
    @current_state = @red_state
  end

  def set_state(state)
    puts "State: -> #{state}" 
    @current_state = state
  end

  def emergency_green!
    @current_state.turn_green
  end

  def emergency_red!
    @current_state.turn_red
  end

  def tick(seconds=1)
    seconds.times { @current_state.tick }
  end

  def current_color
    @current_state.current_color
  end
end