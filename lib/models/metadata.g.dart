// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MetaDataObjectAdapter extends TypeAdapter<MetaDataObject> {
  @override
  final int typeId = 1;

  @override
  MetaDataObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MetaDataObject(
      symbol: fields[0] as String,
      lastRefreshed: fields[1] as String,
      timeZone: fields[2] as String,
      timeSeries: (fields[3] as List)?.cast<DailyPrice>(),
    );
  }

  @override
  void write(BinaryWriter writer, MetaDataObject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.lastRefreshed)
      ..writeByte(2)
      ..write(obj.timeZone)
      ..writeByte(3)
      ..write(obj.timeSeries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaDataObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
