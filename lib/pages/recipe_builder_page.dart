import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:numberpicker/numberpicker.dart';

import '../utils/constants.dart' as Constants;
import '../models/ingredient_prices.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/recipe_ingredient.dart';

class RecipeBuilderPage extends StatefulWidget {
  const RecipeBuilderPage({super.key});

  @override
  State<RecipeBuilderPage> createState() => _RecipeBuilderPageState();
}

class _RecipeBuilderPageState extends State<RecipeBuilderPage> {
  final ingredientPricesBox = Hive.box<IngredientPrices>(Constants.ingredientPricesBox);
  final recipeBox = Hive.box<Recipe>(Constants.recipeBox);
  final List<RecipeIngredient> recipeIngredientList = [];
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final recipeNameController = TextEditingController();

    @override
    void dispose() { 
      super.dispose();
      recipeNameController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.recipeAppBarTitle),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
          vertical: Constants.verticalPadding,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: recipeNameController,
                decoration: const InputDecoration(
                  helperText: Constants.recipeNameHelperText, 
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name for the recipe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Constants.sizedBoxHeight,),
              buildIngredientsDropdown(),
              const SizedBox(height: Constants.sizedBoxHeight,),
              ...buildIngredientsList(textTheme),
              const SizedBox(height: Constants.sizedBoxHeight * 2,),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Save
                  }
                },
                child: const Text(Constants.recipeSaveButtonText),
              ),
            ],
          )
        ),
      ),
    );
  }

  DropdownButton buildIngredientsDropdown() {
    List<Ingredient> ingredients = [];
    List<IngredientPrices> ingredientPrices = ingredientPricesBox.values.toList();
    
    ingredientPrices.forEach((prices) {
      prices.ingredients.forEach((ingredient) {
        var duplicateFound = ingredients.any((i) => ingredient.name == i.name);
        if (!duplicateFound) {
          ingredients.add(ingredient);
        }
      });
    });

    return DropdownButton(
      icon: Constants.recipeDropdownIcon,
      hint: const Text(Constants.recipeDropdownHintText),
      onChanged: (value) {
        setState(() {
          var recipeIngredient = RecipeIngredient(value, 1);

          if (!recipeIngredientList.any(
            (ri) => ri.ingredient.name == recipeIngredient.ingredient.name
          )) {
            recipeIngredientList.add(recipeIngredient);
          }
        });
      },
      items: ingredients.map((ingredient) => DropdownMenuItem(
        value: ingredient,
        child: Text(ingredient.name),
      )).toList(),
    );
  }

  List<Dismissible> buildIngredientsList(TextTheme textTheme) => recipeIngredientList.map(
    (recipeIngredient) => Dismissible(
      key: ValueKey(recipeIngredient),
      onDismissed: (direction) {
        recipeIngredientList.remove(recipeIngredient);
      },
      child: Card(
        child: ListTile(
          leading: InkWell(
            onTap: () async {
              var majorValue = 0;
              var minorValue = 0;

              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    '${Constants.amountSelectorTitle}: '
                    '$majorValue.$minorValue'
                    '${recipeIngredient.ingredient.units}',
                  ),
                  content: StatefulBuilder(
                    builder: (context, setState) => Row(
                      children: [
                        NumberPicker(
                          minValue: 0,
                          maxValue: 99,
                          value: majorValue,
                          onChanged: (value) {
                            setState(() => majorValue = value);
                          },
                        ),
                        NumberPicker(
                          minValue: 0,
                          maxValue: 9,
                          value: minorValue,
                          onChanged: (value) {
                            setState(() => minorValue = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Constants.purple,
              foregroundColor: Constants.creamyWhite,
              child: Text(
                '${recipeIngredient.amount}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          title: Text(
            recipeIngredient.ingredient.name,
            style: textTheme.titleMedium?.copyWith(
              color: Constants.creamyWhite,
            ),
          ),
          subtitle: Text(
            recipeIngredient.ingredient.units,
            style: textTheme.bodyMedium?.copyWith(
                color: Constants.creamyWhite,
              ),
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                recipeIngredientList.remove(recipeIngredient);
              });
            },
            icon: Constants.recipeDeleteIcon,
          ),
        ),
      ),
    ),
  ).toList();
}