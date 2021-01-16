import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Presentation {
  static TextStyle getStyle() {
    return TextStyle(inherit: false, color: Colors.black, fontSize: 16);
  }

  static Icon getIcon(int value) {
    if (value == 1) {
      return Icon(
        Icons.arrow_upward,
        color: Colors.green,
      );
    } else if (value == -1) {
      return Icon(
        Icons.arrow_downward,
        color: Colors.red,
      );
    } else {
      return Icon(
        Icons.arrow_forward,
        color: Colors.blue,
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
          child: getIcon(value),
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

  static Icon getBigIcon(int variation) {
    if (variation == 1) {
      return Icon(
        Icons.arrow_upward,
        color: Colors.green,
        size: 40,
      );
    } else if (variation == -1) {
      return Icon(
        Icons.arrow_downward,
        color: Colors.red,
        size: 40,
      );
    } else {
      return Icon(
        Icons.arrow_forward,
        color: Colors.blue,
        size: 40,
      );
    }
  }
}
