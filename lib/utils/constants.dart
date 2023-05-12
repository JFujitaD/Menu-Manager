import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

// Global
const appName = 'Menu Manager';
const verticalPadding = 30.0;
const listPadding = 5.0;
const sizedBoxHeight = 25.0;
const sizedBoxWidth = 15.0;

// Colors
const purple = Color(0xFF3D405B);
const creamyWhite = Color(0xFFF4F1DE);
const orange = Color(0xFFE07A5F);
const teal = Color(0xFF81B29A);
const darkYellow = Color(0xFFF2CC8F);

// Hive
const recipeBox = 'recipeBox';
const recipeIngredientBox = 'recipeIngredientBox';
const ingredientPricesBox = 'ingredientPricesBox';
const ingredientBox = 'ingredientBox';

// Bottom Navigation
const importIcon = Icon(Ionicons.duplicate_outline);
const importLabel = 'Import';
const recipesIcon = Icon(Ionicons.restaurant_outline);
const recipesLabel = 'Recipes';
const timestampsIcon = Icon(Ionicons.newspaper_outline);
const timestampsLabel = 'Timestamps';

// Import Page
const importIconButton = Icon(Icons.add_chart);
const importHeadline = 'Import your file here';
const emptyFileLabel = 'No file chosen';

// Recipes Page
const recipeAppBarTitle = 'New Recipe';
const addRecipeIcon = Icon(Ionicons.bulb_outline);
const recipeNameHelperText = 'Recipe Name';
const recipeSaveButtonText = 'Save New Recipe';
const recipeDropdownHintText = ' Add Ingredient ';
const recipeDropdownIcon = Icon(Ionicons.add_circle_outline);
const recipeDeleteIcon = Icon(Ionicons.remove_circle_outline);
const amountSelectorTitle = 'Selected Amount';