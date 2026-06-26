class Ingredient
  attr_accessor :type, :qty, :price, :threshold

  def initialize(type, qty, price, threshold)
    @type = type
    @qty = qty
    @price = price
    @threshold = threshold
  end

  def is_low?
    puts "#{@type} is low" if @qty < @threshold
  end 

  def to_s
    "#{qty} units of #{type} ($#{price} each)"
  end

  def reduceQuantity(qty)
    return false if qty > @qty

    @qty -= qty
    true
  end

  def addQuantity(qty)
    @qty += qty
    true
  end
end

module IngredientType
  COFFEE = "COFFEE"
  WATER = "WATER"
  MILK = "MILK"
  SUGAR = "SUGAR"
end