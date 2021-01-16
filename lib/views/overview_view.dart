import 'dart:convert';

import 'package:bdebtrader/models/overview.dart';
import 'package:bdebtrader/services/alphavantage.dart';
import 'package:flutter/material.dart';

class OverViewView extends StatelessWidget {

  final String symbol;

  OverViewView({this.symbol});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AlphaVantage.getOverview(symbol),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) {
            return Container(
              color: Colors.white,
              child: Center(child: Text(snapshot.error),),
            );
          } else {
            var temp = jsonDecode(snapshot.data);
            OverView overView = OverView.fromJson(temp);

            return Container(
              color: Colors.white,child: Text(overView.address, style: TextStyle(inherit: false, color: Colors.black),));
          }
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }
}