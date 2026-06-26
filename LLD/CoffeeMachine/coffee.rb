require './recipe'

class Coffee
  attr_accessor :name, :ingredients

  def initialize(name, ingredients)
    @name = name
    @recipe = Recipe.new(name + " - recipe", ingredients)
  end

  def can_make(available_ingredients)
    @recipe.can_make(available_ingredients)
  end

  def ingredients
    @recipe.ingredients
  end

  def price
    @recipe.price
  end
end