import 'package:flutter/material.dart';

class TimeComponent extends StatelessWidget {
  final String time;
  const TimeComponent({Key key,@required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.watch_later,
          color: Colors.grey,
          size: 15,
        ),
        SizedBox(width:2),
        Text(
          time,
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
      ],
    );
  }
}
