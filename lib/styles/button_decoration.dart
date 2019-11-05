import 'package:flutter/material.dart';

BoxDecoration buttonDecoration = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Color(0xFFDBE7F5),
      offset: Offset(1.0, 10.0),
      blurRadius: 10.0,
    ),
  ],
  borderRadius: BorderRadius.circular(5.0),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.6],
    colors: [
      Color(0xFF3741AE),
      Color(0xFF6719A5),
    ],
  ),
);

BoxDecoration buttonWithoutGradient = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: Color(0xFFDBE7F5),
      offset: Offset(1.0, 10.0),
      blurRadius: 10.0,
    ),
  ],
  borderRadius: BorderRadius.circular(5.0),
 color: Colors.white
);
