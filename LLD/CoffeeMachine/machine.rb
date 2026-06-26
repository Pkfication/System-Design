class Machine
  attr_accessor :id, :ingredients, :menu, :ingredients_hash

  def initialize(id, ingredients, menu)
    @id = id 
    @ingredients_hash = ingredients.to_h { |ingredient| [ingredient.type, ingredient] }

    @menu = menu
    @current_coffee = nil
  end

  def select_coffee(coffee)
    @select_coffee = coffee
  end

  def dispense_coffee
    return false unless @select_coffee
    return false unless @select_coffee.can_make(@ingredients_hash)
    
    @select_coffee.ingredients.each do |ingredient|
      type = ingredient.type
      @ingredients_hash[type].reduceQuantity(ingredient.qty)

      @ingredients_hash[type].is_low?
    end

    puts @select_coffee.price
  end

  def display_menu
    available_drinks = []
    @menu.each do |item|
      if item.can_make(@ingredients_hash)
        available_drinks << item
      end
    end

    puts "All Available Drink"
    available_drinks.each_with_index { |d, index| puts "#{index + 1}. #{d.name}"}
  end

end