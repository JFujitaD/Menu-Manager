import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './utils/constants.dart' as Constants;
import './utils/app_theme.dart' as AppTheme;
import './pages/home_page.dart';
import 'models/recipe.dart';
import 'models/recipe_ingredient.dart';
import 'models/ingredient_prices.dart';
import 'models/ingredient.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(RecipeIngredientAdapter());
  Hive.registerAdapter(IngredientPricesAdapter());
  Hive.registerAdapter(IngredientAdapter());

  await Hive.openBox<Recipe>(Constants.recipeBox);
  await Hive.openBox<RecipeIngredient>(Constants.recipeIngredientBox);
  await Hive.openBox<IngredientPrices>(Constants.ingredientPricesBox);
  await Hive.openBox<Ingredient>(Constants.ingredientBox);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: Constants.appName,
    theme: AppTheme.primaryTheme,
    home: const HomePage(),
  ));
}