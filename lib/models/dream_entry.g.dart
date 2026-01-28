// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DreamEntryAdapter extends TypeAdapter<DreamEntry> {
  @override
  final int typeId = 0;

  @override
  DreamEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DreamEntry(
      id: fields[0] as String,
      text: fields[1] as String,
      date: fields[2] as DateTime,
      mood: fields[3] as String,
      secondaryMoods: (fields[4] as List?)?.cast<String>(),
      moodIntensity: fields[5] as int?,
      vividness: fields[6] as int?,
      interpretation: fields[7] as String,
      title: fields[8] as String?,
      isFavorite: fields[9] as bool,
      astronomicalEvents: (fields[10] as List?)?.cast<String>(),
      guideStage: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DreamEntry obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.mood)
      ..writeByte(4)
      ..write(obj.secondaryMoods)
      ..writeByte(5)
      ..write(obj.moodIntensity)
      ..writeByte(6)
      ..write(obj.vividness)
      ..writeByte(7)
      ..write(obj.interpretation)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.isFavorite)
      ..writeByte(10)
      ..write(obj.astronomicalEvents)
      ..writeByte(11)
      ..write(obj.guideStage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DreamEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
