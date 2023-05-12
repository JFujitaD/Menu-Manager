import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../utils/constants.dart' as Constants;
import '../models/ingredient_prices.dart';
import '../utils/date_helper.dart';
import '../models/recipe.dart';

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
      // TODO
    },
    child: Card(
      child: ListTile(
        title: Text(
          recipe.name,
          style: textTheme.titleMedium?.copyWith(
            color: Constants.creamyWhite,
          ),
        ),
      ),
    ),
  )).toList();
}