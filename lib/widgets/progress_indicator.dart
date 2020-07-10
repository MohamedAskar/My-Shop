import 'package:flutter/material.dart';

class PageProgressIndicator extends StatefulWidget {
  @override
  _PageProgressIndicatorState createState() => _PageProgressIndicatorState();
}

class _PageProgressIndicatorState extends State<PageProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 12,
          ),
          Text(
            'Loading Data...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
