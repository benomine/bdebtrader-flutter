import 'dart:convert';

import 'package:bdebtrader/models/dailyprice.dart';
import 'package:bdebtrader/models/metadata.dart';
import 'package:bdebtrader/services/alphavantage.dart';
import 'package:bdebtrader/utils/presentation.dart';
import 'package:bdebtrader/views/customrow.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

final customRowKey = GlobalKey<CustomRowState>();

class LineChartViewBis extends StatelessWidget {
  final String symbol;
  final String name;

  LineChartViewBis({@required this.symbol, @required this.name});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //future: AlphaVantage.getDailyTimeSeries(args),
        future: AlphaVantage.getDailyTimeSeries(symbol),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));
          } else {
            var temp = jsonDecode(snapshot.data);
            var lastRefreshed = temp['Meta Data']['3. Last Refreshed'];
            var timeZone = temp['Meta Data']['5. Time Zone'];
            var time = temp['Time Series (Daily)'] as Map<String, dynamic>;
            List<DailyPrice> liste = [];
            time.entries.forEach((element) {
              liste.add(DailyPrice.fromJson(element.value, element.key));
            });
            liste = liste.reversed.toList();
            for(var i = 0; i<liste.length; i++) {
              if(i == 0) {
                liste[i].variation = 0;
              } else {
                var variation = liste[i].dailyClose - liste[i-1].dailyClose;
                liste[i].variation = variation < 0 ? -1 : variation == 0 ? 0 : 1;
              }
            }
            var size = liste.length - 1;
            List<String> dates = time.keys.toList();
            MetaDataObject metaDataObject = MetaDataObject(lastRefreshed: lastRefreshed, symbol: symbol, timeSeries: liste, timeZone: timeZone, name: name);
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 10, left: 10, top: 30, bottom: 0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            symbol,
                            style: TextStyle(
                                inherit: false,
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                inherit: false,
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                color: Color(0xff232d37)),
                            child: LineChart(
                              mainData(liste, context),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Presentation.getRow("Time Zone", timeZone),
                          Presentation.getRow("Last Refreshed", lastRefreshed),
                          CustomRow(
                            key: customRowKey,
                            dailyPrice: liste[size],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            RaisedButton(
                              hoverColor: Color(0xff336699),
                              onPressed: () { Navigator.pop(context);},
                              child: Text(
                                "Close",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color(0xff23b6e6),
                            ),
                          ])
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }
}

double getMax(List<DailyPrice> liste) {
  //liste.reduce((curr, next) => curr > next? curr: next))
  List<double> maxValue =
      liste.asMap().entries.map((e) => e.value.dailyClose).toList();
  return maxValue.reduce(max) * 1.2;
}

double getMin(List<DailyPrice> liste) {
  //liste.reduce((curr, next) => curr < next? curr: next))
  List<double> maxValue =
      liste.asMap().entries.map((e) => e.value.dailyClose).toList();
  return maxValue.reduce(min);
}

SideTitles _bottomTitles() {
  return SideTitles(
    showTitles: true,
    rotateAngle: 60,
    getTextStyles: (value) {
      return TextStyle(
        color: Colors.white,
      );
    },
    getTitles: (value) {
      /* final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(value.toInt());
      return  DateFormat.yMd().format(date); */
      return '';
    },
    margin: 8,
    interval: 25,
  );
}

SideTitles _leftTitles() {
  return SideTitles(
    showTitles: true,
    getTextStyles: (value) {
      return TextStyle(color: Colors.white, fontSize: 12);
    },
    getTitles: (value) => value.toString(),
    reservedSize: 28,
    margin: 12,
    interval: 40,
  );
}

double getAvg(List<DailyPrice> liste) {
  return (getMax(liste) + getMin(liste)) / 2.round();
}

LineChartData mainData(List<DailyPrice> dailyPrices, BuildContext context) {
  const List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff23b6e6),
  ];
  List<FlSpot> spots = dailyPrices.asMap().entries.map((e) {
    return FlSpot(e.key.toDouble(), e.value.dailyClose.toDouble());
  }).toList();
  return LineChartData(
    lineTouchData: getLineTouchData(dailyPrices),
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: _bottomTitles(),
      leftTitles: _leftTitles(),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: dailyPrices.length.toDouble() - 1,
    minY: 0,
    maxY: getMax(dailyPrices),
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        colors: gradientColors,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}

LineTouchData getLineTouchData(List<DailyPrice> liste) {
  return LineTouchData(
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((spotIndex) {
          final FlSpot spot = barData.spots[spotIndex];
          if (spot.x == 0 || spot.x == 6) {
            return null;
          }
          return TouchedSpotIndicatorData(
            FlLine(color: Colors.blue, strokeWidth: 4),
            FlDotData(show: true),
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueAccent,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              if (flSpot.x == 0 || flSpot.x == 6) {
                return null;
              }
              return LineTooltipItem(
                '${liste[flSpot.x.toInt()].dailyClose}',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            }).toList();
          }),
      touchCallback: (LineTouchResponse lineTouch) {
        if (lineTouch.lineBarSpots.length == 1 &&
            lineTouch.touchInput is! FlLongPressEnd &&
            lineTouch.touchInput is! FlPanEnd) {
          final value = lineTouch.lineBarSpots;
          value.forEach((element) {
            customRowKey.currentState
                .updateDailyPrice(liste[element.spotIndex]);

            //currentState.dailyPrice = ;
          });
        } else {}
      });
}

Future getOverviewTimeseries(String query) async {
  var overview = AlphaVantage.getOverview(query);
  var meta = AlphaVantage.getDailyTimeSeries(query);
  return await Future.wait([overview, meta]);
}
