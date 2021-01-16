// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailyprice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyPriceAdapter extends TypeAdapter<DailyPrice> {
  @override
  final int typeId = 2;

  @override
  DailyPrice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyPrice(
      dailyDate: fields[0] as String,
      dailyOpen: fields[1] as double,
      dailyHigh: fields[2] as double,
      dailyLow: fields[3] as double,
      dailyClose: fields[4] as double,
      dailyVolume: fields[5] as int,
    )..variation = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, DailyPrice obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.dailyDate)
      ..writeByte(1)
      ..write(obj.dailyOpen)
      ..writeByte(2)
      ..write(obj.dailyHigh)
      ..writeByte(3)
      ..write(obj.dailyLow)
      ..writeByte(4)
      ..write(obj.dailyClose)
      ..writeByte(5)
      ..write(obj.dailyVolume)
      ..writeByte(6)
      ..write(obj.variation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPriceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
