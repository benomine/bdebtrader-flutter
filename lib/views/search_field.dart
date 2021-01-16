import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
          labelText: "Search",
          hintText: "Search a company or symbol",
          suffixIcon: Icon(Icons.search, color: Colors.black,),
          border: InputBorder.none
        ),
      ),
    );
  }
}
