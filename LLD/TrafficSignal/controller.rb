require './road'

main_rd = Road.new("Main St", red: 90, green: 20, yellow: 5)
main_rd.current_color
main_rd.tick(30)

main_rd.handle_emergency

main_rd.current_color
main_rd.tick(61)

main_rd.current_color



