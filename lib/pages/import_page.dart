import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:excel/excel.dart';

import '../utils/constants.dart' as Constants;
import '../models/ingredient_prices.dart';
import '../models/ingredient.dart';
import '../components/file_label.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final ingredientPricesBox = Hive.box<IngredientPrices>(Constants.ingredientPricesBox);
  String filePath = Constants.emptyFileLabel;
  File? file;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 4,
        vertical: Constants.verticalPadding,
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              Constants.importHeadline,
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constants.sizedBoxHeight,),
            const Icon(Ionicons.arrow_down_circle_outline, size: 50,),
            const SizedBox(height: Constants.sizedBoxHeight,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FileLabel(textValue: filePath),
                const SizedBox(width: Constants.sizedBoxWidth,),
                IconButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      String path = result.files.single.path!;
                      file = File(path);
                      setState(() {
                        filePath = path;
                      });
                    } else {
                      // Cancelled
                    }
                  },
                  icon: Constants.importIconButton,
                )
              ],
            ),
            const SizedBox(height: Constants.sizedBoxHeight,),
            ElevatedButton(
              onPressed: () {
                if (file == null) {
                  // File is null
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(Constants.noFileFoundText),
                  ));
                } else {
                  // File will be imported
                  List<Ingredient> ingredients = [];
                  var bytes = file!.readAsBytesSync();
                  var excel = Excel.decodeBytes(bytes);

                  // Search for relevant fields
                  for (var sheet in excel.tables.keys) {
                    for (var row in excel.tables[sheet]!.rows) {
                      debugPrint('${row[0]!.value} ${row[1]!.value}');
                      var ingredient = Ingredient(
                        '${row[0]!.value}',
                        '${row[1]!.value}',
                        double.parse('${row[2]!.value}'
                      ));
                      ingredients.add(ingredient);
                    }
                  }
                  var ingredientPrices  = IngredientPrices(ingredients, DateTime.now());
                  ingredientPricesBox.add(ingredientPrices);
                  
                  setState(() {
                    file = null;
                    filePath = Constants.emptyFileLabel;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(Constants.fileImportedText),
                  ));
                }
              },
              child: const Text(Constants.importButtonText),
            ),
          ],
        ),
      ),
    );
  }
}