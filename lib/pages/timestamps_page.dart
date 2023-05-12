import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menu_manager/pages/timestamp_details_page.dart';

import '../utils/date_helper.dart';
import '../utils/constants.dart' as Constants;
import '../models/ingredient_prices.dart';

class TimestampsPage extends StatefulWidget {
  const TimestampsPage({super.key});

  @override
  State<TimestampsPage> createState() => _TimestampsPageState();
}

class _TimestampsPageState extends State<TimestampsPage> {
  final ingredientPricesBox = Hive.box<IngredientPrices>(Constants.ingredientPricesBox);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: Constants.listPadding,
        horizontal: MediaQuery.of(context).size.width / 4,
      ),
      itemCount: ingredientPricesBox.length,
      itemBuilder: (context, index) {
        IngredientPrices ingredientPrices = ingredientPricesBox.getAt(index)!;

        return Card(
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TimestampDetailsPage(ingredientPrices: ingredientPrices),
                )
              );
            },
            leading: CircleAvatar(
              backgroundColor: Constants.purple,
              foregroundColor: Constants.creamyWhite,
              child: Text(
                DateHelper.prettyMonth(ingredientPrices.dateTime.month),
              ),
            ),
            title: Text(
              DateHelper.prettyDate(ingredientPrices.dateTime),
              style: textTheme.titleMedium?.copyWith(
                color: Constants.creamyWhite,
              ),
            ),
            subtitle: Text(
              'Ingredients: ${ingredientPrices.ingredients.length}',
              style: textTheme.bodyMedium?.copyWith(
                color: Constants.creamyWhite,
              ),
            ),
            trailing: const Icon(Icons.arrow_right),
          ),
        );
      },
    );
  }
}