import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double height;
  final double progress;

  const CustomProgressIndicator({
    Key key,
    this.height = 8,
    this.progress = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity,
      minHeight: height),
      height: height,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [Colors.red, Colors.yellow])),
                      height: height,
                      width: constraints.minWidth/2,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient:
                          LinearGradient(colors: [Colors.yellow, Colors.green])),
                      height: height,
                      width: constraints.minWidth/2,
                    ),
                  ],
                ),
                left: 0,),
            Positioned(
              child: Row(
                children: [
                  Container(
                    height: height,
                    width: constraints.maxWidth,
                  ),
                  Container(
                    color: Colors.grey,
                    height: height,
                    width: constraints.minWidth*(1-progress),
                  )
                ],
              ),
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
