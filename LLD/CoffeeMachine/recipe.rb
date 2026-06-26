class Recipe
  attr_accessor :name, :ingredients

  def initialize(name, ingredients)
    @name = name
    @ingredients = ingredients
  end

  def can_make(available_ingredients)
    return true if ingredients.empty?

    @ingredients.all? do |ingredient|
      type = ingredient.type
      available_ingredients.key?(type) && available_ingredients[type].qty > ingredient.qty
    end
  end

  def price
    @ingredients.sum do |ingredient|
      ingredient.price * ingredient.qty
    end
  end
end