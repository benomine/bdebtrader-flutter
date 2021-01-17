import 'package:bdebtrader/models/dailyprice.dart';
import 'package:bdebtrader/utils/utils.dart';
import 'package:bdebtrader/views/customrow.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Presentation {
  
  static TextStyle getStyle() {
    return TextStyle(inherit: false, color: Colors.black, fontSize: 16);
  }

  static Icon getIcon(int value, double size) {
    if (value == 1) {
      return Icon(
        Icons.arrow_upward,
        color: Colors.green,
        size: size,
      );
    } else if (value == -1) {
      return Icon(
        Icons.arrow_downward,
        color: Colors.red,
        size: size,
      );
    } else {
      return Icon(
        Icons.arrow_forward,
        color: Colors.blue,
        size: size,
      );
    }
  }

  static Row getRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Card(
            child: Text(
              key,
              style: getStyle(),
            ),
          ),
        ),
        Expanded(
            child: Card(
          child: Text(
            value,
            style: getStyle(),
          ),
        ))
      ],
    );
  }

  static Row getRowVariation(String key, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Card(
            child: Text(
              key,
              style: getStyle(),
            ),
          ),
        ),
        Expanded(
            child: Card(
          child: getIcon(value, 24.0),
        ))
      ],
    );
  }

  static FaIcon showCurrencySymbol(String string) {
    if (string == 'CAD') {
      return FaIcon(FontAwesomeIcons.dollarSign);
    } else if (string == 'USD') {
      return FaIcon(FontAwesomeIcons.dollarSign);
    } else if (string == 'EUR') {
      return FaIcon(FontAwesomeIcons.euroSign);
    } else if (string == 'GBP') {
      return FaIcon(FontAwesomeIcons.poundSign);
    } else if (string == 'YEN') {
      return FaIcon(FontAwesomeIcons.yenSign);
    } else {
      return FaIcon(FontAwesomeIcons.moneyBill);
    }
  }

  static SideTitles bottomTitles() {
    return SideTitles(
      showTitles: true,
      rotateAngle: 60,
      getTextStyles: (value) {
        return TextStyle(
          color: Colors.white,
        );
      },
      getTitles: (value) {
        return '';
      },
      margin: 8,
      interval: 25,
    );
  }

  static SideTitles leftTitles() {
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

  static LineTouchData getLineTouchData(
      List<DailyPrice> liste, GlobalKey<CustomRowState> key) {
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
              key.currentState.updateDailyPrice(liste[element.spotIndex]);

              //currentState.dailyPrice = ;
            });
          } else {}
        });
  }

static LineChartData mainData(List<DailyPrice> dailyPrices, BuildContext context, GlobalKey<CustomRowState> key) {
  const List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff23b6e6),
  ];
  List<FlSpot> spots = dailyPrices.asMap().entries.map((e) {
    return FlSpot(e.key.toDouble(), e.value.dailyClose.toDouble());
  }).toList();
  return LineChartData(
    lineTouchData: Presentation.getLineTouchData(dailyPrices, key),
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
      bottomTitles: Presentation.bottomTitles(),
      leftTitles: Presentation.leftTitles(),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: dailyPrices.length.toDouble() - 1,
    minY: 0,
    maxY: Utils.getMax(dailyPrices),
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

}
