import 'package:bdebtrader/models/dailyprice.dart';
import 'package:hive/hive.dart';

part 'metadata.g.dart';

@HiveType(typeId: 1)
class MetaDataObject {
  @HiveField(0)
  String symbol;
  @HiveField(1)
  String lastRefreshed;
  @HiveField(2)
  String timeZone;
  @HiveField(3)
  List<DailyPrice> timeSeries;
  @HiveField(4)
  String name;

  MetaDataObject({ this.symbol, this.lastRefreshed, this.timeZone, this.timeSeries, this.name});
}