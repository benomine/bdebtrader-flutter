import 'dart:convert';

import 'package:bdebtrader/models/metadata.dart';
import 'package:bdebtrader/services/alphavantage.dart';
import 'package:bdebtrader/utils/utils.dart';
import 'package:bdebtrader/utils/presentation.dart';
import 'package:bdebtrader/views/customrow.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';

import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

final customRowKey = GlobalKey<CustomRowState>();

class LineChartView extends StatelessWidget {
  final String symbol;
  final String name;
  final String currency;

  LineChartView({@required this.symbol, @required this.name, this.currency});

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
            var json = jsonDecode(snapshot.data);
            MetaDataObject meta = Utils.extractJson(json, symbol, name);
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
                              onPressed: () { 
                                var box = Hive.box('bdebtrader');
                                if(box.length<5) {box.add(meta);}
                                else { showToastWidget(Text('You can watch 5 symbols at a time')); }
                              },
                              child: Text(
                                "Add to watchlist",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color(0xff23b6e6),
                            ),
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
