import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double height;
  final double width;
  final double progress;

  const CustomProgressIndicator({
    Key key,
    this.height = 8,
    this.width,
    this.progress = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultWidth = MediaQuery.of(context).size.width - 16;
    double actualWidth = width ?? defaultWidth;
    return SizedBox(
      height: height,
      width: actualWidth,
      child: Stack(
        children: [
          Positioned(child: Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.yellow, Colors.green])),
            width: actualWidth,
            height: height,
          ), left: 0,),
          Positioned(child: Container(
            color: Colors.grey,
            width: actualWidth - progress*actualWidth,
            height: height,
          ), right: 0,)
        ],
      ),
    );
  }
}
