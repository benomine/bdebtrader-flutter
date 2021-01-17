import 'dart:convert';

import 'package:bdebtrader/models/dailyprice.dart';
import 'package:bdebtrader/models/metadata.dart';
import 'package:bdebtrader/services/alphavantage.dart';
import 'package:bdebtrader/utils/utils.dart';
import 'package:bdebtrader/utils/presentation.dart';
import 'package:bdebtrader/views/stockview_registered.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MetaCard extends StatelessWidget {
  final MetaDataObject meta;
  final int index;

  MetaCard({this.meta, this.index});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('bdebtrader');
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LineChartViewBis(
                            meta: meta,
                          )));
            },
            onLongPress: () async {
              var formatDate = new DateFormat('yyyy-MM-dd');
              var date = formatDate.parse(meta.lastRefreshed);
              if (date.day != DateTime.now().day &&
                  date.month != DateTime.now().month) {
                var response =
                    await AlphaVantage.getDailyTimeSeries(meta.symbol);
                var temp = jsonDecode(response);
                var time = temp['Time Series (Daily)'] as Map<String, dynamic>;
                List<DailyPrice> liste = [];
                time.entries.forEach((element) {
                  liste.add(DailyPrice.fromJson(element.value, element.key));
                });
                liste = liste.reversed.toList();
                Utils.getVariations(liste);
                meta.lastRefreshed = formatDate.format(DateTime.now());
                meta.timeSeries = liste;
              }
            },
            leading: Presentation.getIcon(meta.timeSeries.last.variation, 40.0),
            title: Text(
                meta.symbol + " " + meta.timeSeries.last.dailyClose.toString()),
            subtitle: Text("Refreshed " + meta.lastRefreshed),
            trailing: IconButton(
              onPressed: () {
                box.deleteAt(index);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red[200],
              ),
            ),
          )
        ],
      ),
    );
  }
}
