import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    print(screenHeight);

    return ClipPath(
      clipper: BottomCurveClipper(),
      child: ControlledAnimation(
          duration: Duration(seconds: 1),
          delay: Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0, end: 1),
          curve: Curves.bounceOut,
          builder: (context, value) {
            return Container(
              height: getContainerHeight(screenHeight),
              color: Colors.orange,
              child: Center(
                child: Transform.scale(
                  scale: value,
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    child: Center(
                      child: Text(
                        'M',
                        style: TextStyle(
                            fontSize: 90.0,
                            color: Colors.orange,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

double getContainerHeight(double screenheight) {
  if (screenheight < 600) {
    return screenheight * 0.3;
  } else if (screenheight < 800) {
    return screenheight * 0.35;
  } else {
    return screenheight * 0.5;
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset startPoint = Offset(0, size.height * 0.85);
    Offset endPoint = Offset(size.width, size.height * 0.85);

    path.lineTo(startPoint.dx, startPoint.dy);
    path.quadraticBezierTo(
        size.width * 0.5, size.height, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
