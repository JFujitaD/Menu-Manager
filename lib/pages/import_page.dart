import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ionicons/ionicons.dart';

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
            )
          ],
        ),
      ),
    );
  }
}