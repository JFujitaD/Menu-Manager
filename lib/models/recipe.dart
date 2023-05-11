import 'package:hive/hive.dart';

import 'recipe_ingredient.dart';

part 'recipe.g.dart';

@HiveType(typeId: 4)
class Recipe extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<RecipeIngredient> ingredients;

  Recipe(this.name, this.ingredients);
}