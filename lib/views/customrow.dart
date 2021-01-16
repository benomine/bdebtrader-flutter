import 'package:bdebtrader/models/dailyprice.dart';
import 'package:bdebtrader/utils/presentation.dart';
import 'package:flutter/material.dart';

class CustomRow extends StatefulWidget {

  final DailyPrice dailyPrice;
  CustomRow({Key key, this.dailyPrice}):super(key: key);

  @override
  CustomRowState createState() => CustomRowState();
}

class CustomRowState extends State<CustomRow> {
  final key = GlobalKey();

  DailyPrice dailyPrice;

  void updateDailyPrice(DailyPrice newDailyPrice) {
    setState(() {
      dailyPrice = newDailyPrice;
    });
  }
  
  @override
  void initState() {
    super.initState();
    dailyPrice = widget.dailyPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Presentation.getRow("Date", dailyPrice.dailyDate),
        Presentation.getRow("Daily Open", dailyPrice.dailyOpen.toString()),
        Presentation.getRow("Daily Close", dailyPrice.dailyClose.toString()),
        Presentation.getRow("Daily Low", dailyPrice.dailyLow.toString()),
        Presentation.getRow("Daily High", dailyPrice.dailyHigh.toString()),
        Presentation.getRow("Daily Volume", dailyPrice.dailyVolume.toString()),
        Presentation.getRowVariation("Variation", dailyPrice.variation),
      ],
    );
    
    
    
    /* Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Card(child: Text("Date")),
            Card(child: Text("Daily Open")),
            Card(child: Text("Daily Close")),
            Card(child: Text("Daily Low")),
            Card(child: Text("Daily High")),
          ],
        ),
        Column(
          children: [
            Card(child: Text(dailyPrice.dailyDate)),
            Card(child: Text(dailyPrice.dailyOpen.toString())),
            Card(child: Text(dailyPrice.dailyClose.toString())),
            Card(child: Text(dailyPrice.dailyLow.toString())),
            Card(child: Text(dailyPrice.dailyHigh.toString())),
          ],
        ),
      ],      
    ); */
  }
}