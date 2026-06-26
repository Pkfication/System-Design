require './coffee'
require './ingredient'
require './machine'

milk = Ingredient.new(IngredientType::MILK, 100, 1, 10)
coffee = Ingredient.new(IngredientType::COFFEE, 100, 2, 10)
water = Ingredient.new(IngredientType::WATER, 100, 0.5, 10)


latte_recipe = [
  Ingredient.new(IngredientType::MILK, 1, 1, nil),
  Ingredient.new(IngredientType::COFFEE, 1, 1, nil)
]

mocha_recipe = [
  Ingredient.new(IngredientType::MILK, 2, 1, nil),
  Ingredient.new(IngredientType::COFFEE, 1, 1, nil)
]


latte = Coffee.new("Latte", latte_recipe)
mocha = Coffee.new("Mocha", mocha_recipe)

machine = Machine.new("001", [milk, coffee, water], [latte, mocha])
machine.display_menu

puts machine.ingredients_hash
machine.select_coffee(latte)
machine.dispense_coffee

puts machine.ingredients_hash

machine.select_coffee(mocha)
machine.dispense_coffee

puts machine.ingredients_hash