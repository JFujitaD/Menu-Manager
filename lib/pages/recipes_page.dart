import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../utils/constants.dart' as Constants;
import '../models/ingredient_prices.dart';
import '../utils/date_helper.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final ingredientPricesBox = Hive.box<IngredientPrices>(Constants.ingredientPricesBox);
  final recipeBox = Hive.box<Recipe>(Constants.recipeBox);
  IngredientPrices? selectedIngredientPrices;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
          vertical: Constants.verticalPadding,
        ),
        child: Column(
          children: [
            buildDropdownButton(textTheme),
            const SizedBox(height: Constants.sizedBoxHeight,),
            ...buildRecipeList(textTheme),
          ],
        ),
      ),
    );
  }

  DropdownButton buildDropdownButton(TextTheme textTheme) {
    return DropdownButton(
      value: selectedIngredientPrices,
      icon: Constants.recipeTimestampDropdownIcon,
      isExpanded: true,
      dropdownColor: Constants.teal,
      hint: const Text(Constants.recipeTimestampHintText),
      onChanged: (value) => setState(() {
        selectedIngredientPrices = value;
      }),
      items: ingredientPricesBox.values.map((ingredientPrices) => DropdownMenuItem(
        value: ingredientPrices,
        child: Text(
          ' ${DateHelper.prettyDate(ingredientPrices.dateTime)}',
          style: textTheme.bodyLarge!.copyWith(
            color: ingredientPrices == selectedIngredientPrices ? Constants.purple : Constants.creamyWhite,
          ),
        ),
      )).toList(),
    );
  }

  List<Dismissible> buildRecipeList(textTheme) => recipeBox.values.map((recipe) => Dismissible(
    key: ValueKey(recipe),
    onDismissed: (direction) {
      int index = recipeBox.values.toList().indexOf(recipe);
      recipeBox.deleteAt(index);
    },
    child: Card(
      child: ListTile(
        title: Text(
          recipe.name,
          style: textTheme.titleMedium?.copyWith(
            color: Constants.creamyWhite,
          ),
        ),
        subtitle: Text(
          'Ingredients: ${recipe.ingredients.length}',
          style: textTheme.bodyMedium?.copyWith(
            color: Constants.creamyWhite,
          ),
        ),
        trailing: Text(
          selectedIngredientPrices != null ?
            '\$${calculateRecipePrice(selectedIngredientPrices, recipe).toStringAsFixed(2)}'
            : '\$??.??',
          style: textTheme.titleMedium?.copyWith(
            color: Constants.creamyWhite,
          ),
        ),
      ),
    ),
  )).toList();
}

double calculateRecipePrice(IngredientPrices? ingredientPrices, Recipe recipe) {
  if (ingredientPrices == null) {
    return 0.0;
  }

  double totalPrice = 0;

  recipe.ingredients.forEach((recipeIngredient) { 
    Ingredient matchedIngredient = ingredientPrices!.ingredients.firstWhere(
      (i) => recipeIngredient.ingredient.name == i.name
    );
    totalPrice += recipeIngredient.amount * matchedIngredient.price;
  });

  return totalPrice;
}