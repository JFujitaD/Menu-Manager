import 'package:hive/hive.dart';

import 'ingredient.dart';

part 'recipe_ingredient.g.dart';

@HiveType(typeId: 3)
class RecipeIngredient extends HiveObject {
  @HiveField(0)
  Ingredient ingredient;

  @HiveField(1)
  double amount;

  RecipeIngredient(this.ingredient, this.amount);
}