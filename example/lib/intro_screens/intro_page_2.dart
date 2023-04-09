import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: 70), //apply padding to some sides only
            child: Text('CONNECT  To  NEUROLYX',
                style: TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0), //position of shadow
                      blurRadius: 7.0, //blur intensity of shadow
                      color: Colors.black
                          .withOpacity(0.8), //color of shadow with opacity
                    ),
                  ],
                  height: 0,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center),
          ),
          SvgPicture.asset(
            'assets/images/android.svg',
            height: 250,
            width: 250,
          ),
          Padding(
            padding:
                EdgeInsets.only(bottom: 30), //apply padding to some sides only
            child: Text('Connect the app to the device using BLUETOOTH',
                style: TextStyle(
                  height: 0,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
