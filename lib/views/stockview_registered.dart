import 'package:bdebtrader/models/metadata.dart';
import 'package:bdebtrader/utils/presentation.dart';
import 'package:bdebtrader/views/customrow.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

final customRowKey = GlobalKey<CustomRowState>();

class LineChartViewBis extends StatelessWidget {
  final MetaDataObject meta;

  LineChartViewBis({this.meta});

  @override
  Widget build(BuildContext context) {
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
                    meta.symbol,
                    style: TextStyle(
                        inherit: false,
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    meta.name,
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
                      Presentation.mainData(meta.timeSeries, context, customRowKey),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Presentation.getRow("Time Zone", meta.timeZone),
                  Presentation.getRow("Last Refreshed", meta.lastRefreshed),
                  CustomRow(
                    key: customRowKey,
                    dailyPrice: meta.timeSeries.last,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          hoverColor: Color(0xff336699),
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
}
