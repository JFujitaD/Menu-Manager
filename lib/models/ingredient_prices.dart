import 'package:hive/hive.dart';

import 'ingredient.dart';

part 'ingredient_prices.g.dart';

@HiveType(typeId: 2)
class IngredientPrices extends HiveObject {
  @HiveField(0)
  List<Ingredient> ingredients;

  @HiveField(1)
  DateTime dateTime;

  IngredientPrices(this.ingredients, this.dateTime);
}