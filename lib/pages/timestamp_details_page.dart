import 'package:flutter/material.dart';
import 'package:menu_manager/utils/date_helper.dart';

import '../utils/constants.dart' as Constants;
import '../models/ingredient_prices.dart';
import '../models/ingredient.dart';

class TimestampDetailsPage extends StatelessWidget {
  final IngredientPrices ingredientPrices;

  const TimestampDetailsPage({required this.ingredientPrices, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(DateHelper.prettyDate(ingredientPrices.dateTime)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: Constants.listPadding,
          horizontal: MediaQuery.of(context).size.width / 4,
        ),
        itemCount: ingredientPrices.ingredients.length,
        itemBuilder: (context, index) {
          Ingredient ingredient = ingredientPrices.ingredients[index];

          return Card(
            child: ListTile(
              title: Text(
                ingredient.name,
                style: textTheme.titleMedium?.copyWith(
                  color: Constants.creamyWhite,
                ),
              ),
              subtitle: Text(
                'Units: ${ingredient.units}',
                style: textTheme.bodyMedium?.copyWith(
                  color: Constants.creamyWhite,
                ),
              ),
              trailing: Text(
                '\$${ingredient.price.toStringAsFixed(2)}',
                style: textTheme.titleMedium?.copyWith(
                  color: Constants.creamyWhite,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}