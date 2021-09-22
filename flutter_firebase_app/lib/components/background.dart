import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          //alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Image.asset(
                "assets/images/top.png",
                fit: BoxFit.fill,
                height: 100,
                width: size.width,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
