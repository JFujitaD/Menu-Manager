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
  final recipeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              buildIngredientsDropdown(textTheme),
              const SizedBox(height: Constants.sizedBoxHeight,),
              ...buildIngredientsList(textTheme),
              const SizedBox(height: Constants.sizedBoxHeight * 2,),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Recipe newRecipe = Recipe(recipeNameController.text, recipeIngredientList);
                    recipeBox.add(newRecipe);

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(Constants.saveSuccessfulMessage),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(Constants.saveFailureMessage),
                    ));
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

  DropdownButton buildIngredientsDropdown(TextTheme textTheme) {
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
      dropdownColor: Constants.teal,
      isExpanded: true,
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
        child: Text(
          ingredient.name,
          style: textTheme.bodyLarge!.copyWith(
            color: Constants.creamyWhite,
          ),
        ),
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

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    recipeIngredient.ingredient.name,
                  ),
                  content: StatefulBuilder(
                    builder: (context, setState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            NumberPicker(
                              minValue: 0,
                              maxValue: 99,
                              value: majorValue,
                              selectedTextStyle: const TextStyle(
                                color: Constants.teal,
                                fontSize: Constants.numberSelectorSelectedFontSize,
                              ),
                              onChanged: (value) {
                                setState(() => majorValue = value);
                              },
                            ),
                            NumberPicker(
                              minValue: 0,
                              maxValue: 9,
                              value: minorValue,
                              selectedTextStyle: const TextStyle(
                                color: Constants.teal,
                                fontSize: Constants.numberSelectorSelectedFontSize,
                              ),
                              onChanged: (value) {
                                setState(() => minorValue = value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: Constants.sizedBoxHeight,),
                        Text(
                          '${Constants.recipeAmountLabel}: '
                          '$majorValue.$minorValue '
                          '${recipeIngredient.ingredient.units}(s)'
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(Constants.recipeDialogCancelButtonLabel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          double.parse('$majorValue.$minorValue'),
                        );
                      },
                      child: const Text(Constants.recipeDialogSaveButtonLabel),
                    ),
                  ],
                ),
              ).then((value) => setState(() {
                recipeIngredient.amount = value;
              },));
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