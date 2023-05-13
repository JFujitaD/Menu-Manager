import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../utils/constants.dart' as Constants;
import '../pages/import_page.dart';
import '../pages/recipes_page.dart';
import '../pages/timestamps_page.dart';
import '../pages/recipe_builder_page.dart';
import '../models/recipe.dart';
import '../models/recipe_ingredient.dart';
import '../models/ingredient_prices.dart';
import '../models/ingredient.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final hiveBoxes = <String, Box<dynamic>> {
    'recipe': Hive.box<Recipe>(Constants.recipeBox),
    'recipeIngredients': Hive.box<RecipeIngredient>(Constants.recipeIngredientBox),
    'ingredientPrices': Hive.box<IngredientPrices>(Constants.ingredientPricesBox),
    'ingredient': Hive.box<Ingredient>(Constants.ingredientBox),
  };
  final navigationPages = [
    const ImportPage(),
    const RecipesPage(),
    const TimestampsPage(),
  ];
  var selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Constants.appName),
        actions: [
          selectedPage == 1 ? 
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RecipeBuilderPage(),
                  ),
                );
              },
              icon: Constants.addRecipeIcon,
            )
            : const SizedBox(),
          // DEBUGGING ONLY
          // IconButton(
          //   onPressed: () {
          //     hiveBoxes.forEach((key, value) {
          //       value.deleteFromDisk();
          //     });
          //   },
          //   icon: const Icon(Icons.warning),
          // ),
          // DEBUGGING PURPOSES ONLY
          // IconButton(
          //   onPressed: () async {
          //             List<Ingredient> ingredients1 = [
          //               Ingredient('Pork Cutlets', 'lbs', 1.50),
          //               Ingredient('Fresh Parsley', 'oz', 0.50),
          //               Ingredient('Seaweed', 'oz', 0.70),
          //               Ingredient('Rice', 'cups', 1.49),
          //             ];
          //             DateTime now1 = DateTime(1999, 2, 14);
          //             IngredientPrices ingredientPrices1 = IngredientPrices(ingredients1, now1);
          //             List<Ingredient> ingredients2 = [
          //               Ingredient('Pork Cutlets', 'lbs', 5.29),
          //               Ingredient('Fresh Parsley', 'oz', 1.73),
          //               Ingredient('Seaweed', 'oz', 1.89),
          //               Ingredient('Rice', 'cups', 3.00),
          //             ];
          //             DateTime now2 = DateTime(2020, 4, 27);
          //             IngredientPrices ingredientPrices2 = IngredientPrices(ingredients2, now2);
          //             List<Ingredient> ingredients3 = [
          //               Ingredient('Pork Cutlets', 'lbs', 8.99),
          //               Ingredient('Fresh Parsley', 'oz', 5.00),
          //               Ingredient('Seaweed', 'oz', 1.99),
          //               Ingredient('Rice', 'cups', 3.99),
          //             ];
          //             DateTime now3 = DateTime(2026, 3, 13);
          //             IngredientPrices ingredientPrices3 = IngredientPrices(ingredients3, now3);

          //             await hiveBoxes['ingredientPrices']?.add(ingredientPrices1);
          //             await hiveBoxes['ingredientPrices']?.add(ingredientPrices2);
          //             await hiveBoxes['ingredientPrices']?.add(ingredientPrices3);
          //   },
          //   icon: const Icon(Icons.add_business_sharp),
          // ),
        ],
      ),
      body: navigationPages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: (value) => setState(() {
          selectedPage = value;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Constants.importIcon,
            label: Constants.importLabel,
          ),
          BottomNavigationBarItem(
            icon: Constants.recipesIcon,
            label: Constants.recipesLabel,
          ),
          BottomNavigationBarItem(
            icon: Constants.timestampsIcon,
            label: Constants.timestampsLabel,
          ),
        ],
      ),
    );
  }
}