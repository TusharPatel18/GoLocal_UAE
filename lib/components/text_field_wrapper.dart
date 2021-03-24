import 'package:flutter/material.dart';
import 'package:go_local_vendor/resources/style_resources.dart';

class TextFieldWrapper extends StatelessWidget {
  const TextFieldWrapper({
    @required this.child,
  }) : super();

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 6,
              color: StyleResources.shadowColor,
            ),
          ]
      ),
      child: child,
    );
  }
}
