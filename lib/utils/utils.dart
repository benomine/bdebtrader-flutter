import 'dart:math';

import 'package:bdebtrader/models/dailyprice.dart';
import 'package:bdebtrader/models/metadata.dart';

class Utils {
  static getVariations(List<DailyPrice> liste) {
    for (var i = 0; i < liste.length; i++) {
      if (i == 0) {
        liste[i].variation = 0;
      } else {
        var variation = liste[i].dailyClose - liste[i - 1].dailyClose;
        liste[i].variation = variation < 0
            ? -1
            : variation == 0
                ? 0
                : 1;
      }
    }
  }

  static MetaDataObject extractJson(dynamic json, String symbol, String name) {
    var lastRefreshed = json['Meta Data']['3. Last Refreshed'];
    var timeZone = json['Meta Data']['5. Time Zone'];
    var time = json['Time Series (Daily)'] as Map<String, dynamic>;
    List<DailyPrice> liste = [];
    time.entries.forEach((element) {
      liste.add(DailyPrice.fromJson(element.value, element.key));
    });
    liste = liste.reversed.toList();
    getVariations(liste);
    return MetaDataObject(
        lastRefreshed: lastRefreshed,
        symbol: symbol,
        timeSeries: liste,
        timeZone: timeZone,
        name: name);
  }

  static double getMax(List<DailyPrice> liste) {
    //liste.reduce((curr, next) => curr > next? curr: next))
    List<double> maxValue =
        liste.asMap().entries.map((e) => e.value.dailyClose).toList();
    return maxValue.reduce(max) * 1.2;
  }

  static double getMin(List<DailyPrice> liste) {
    //liste.reduce((curr, next) => curr < next? curr: next))
    List<double> maxValue =
        liste.asMap().entries.map((e) => e.value.dailyClose).toList();
    return maxValue.reduce(min);
  }

  static double getAvg(List<DailyPrice> liste) {
    return (getMax(liste) + getMin(liste)) / 2.round();
  }
}
