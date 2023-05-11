// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_prices.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientPricesAdapter extends TypeAdapter<IngredientPrices> {
  @override
  final int typeId = 2;

  @override
  IngredientPrices read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientPrices(
      (fields[0] as List).cast<Ingredient>(),
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientPrices obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ingredients)
      ..writeByte(1)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientPricesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
