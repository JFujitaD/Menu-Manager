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
          IconButton(
            onPressed: () {
              hiveBoxes.forEach((key, value) {
                value.deleteFromDisk();
              });
            },
            icon: const Icon(Icons.warning),
          ),
          // DEBUGGING PURPOSES ONLY
          IconButton(
            onPressed: () async {
                      List<Ingredient> ingredients = [
                        Ingredient('Pork Cutlets', 'lbs', 3.29),
                        Ingredient('Fresh Parsley', 'oz', 0.73),
                        Ingredient('Seaweed', 'oz', 0.89),
                        Ingredient('Rice', 'cups', 1.49),
                      ];
                      DateTime now = DateTime.now();
                      IngredientPrices ingredientPrices = IngredientPrices(ingredients, now);
                      await hiveBoxes['ingredientPrices']?.add(ingredientPrices);
                      await ingredientPrices.save();
            },
            icon: const Icon(Icons.add_business_sharp),
          ),
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