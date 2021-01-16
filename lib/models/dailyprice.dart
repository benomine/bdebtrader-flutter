import 'package:hive/hive.dart';

part 'dailyprice.g.dart';

@HiveType(typeId: 2)
class DailyPrice {
  @HiveField(0)
  final String dailyDate;
  @HiveField(1)
  final double dailyOpen;
  @HiveField(2)
  final double dailyHigh;
  @HiveField(3)
  final double dailyLow;
  @HiveField(4)
  final double dailyClose;
  @HiveField(5)
  final int dailyVolume;
  @HiveField(6)
  int variation;

  DailyPrice(
      {this.dailyDate,
      this.dailyOpen,
      this.dailyHigh,
      this.dailyLow,
      this.dailyClose,
      this.dailyVolume});

  factory DailyPrice.fromJson(Map<String, dynamic> json, String key) {
    return DailyPrice(
        dailyDate: key,
        dailyOpen: double.parse(json['1. open']),
        dailyClose: double.parse(json['4. close']),
        dailyHigh: double.parse(json['2. high']),
        dailyLow: double.parse(json['3. low']),
        dailyVolume: int.parse(json['6. volume']));
  }
}