import 'package:flutter/material.dart';

class RectangleClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
var path = new Path();
    path.lineTo(0.0, size.height-60);
    var firstControlPoint = Offset(size.width / 2, 250.0);
    var firstEndPoint = Offset(0.0, size.height-60);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width / 2, 250.0);
    var secondEndPoint = Offset(size.width, size.height-60);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0.0); 
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}