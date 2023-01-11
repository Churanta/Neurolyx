import 'package:flutter/material.dart';

import './MainPage.dart';

//adding new pages
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'intro_screens/intro_page_1.dart';
import 'intro_screens/intro_page_2.dart';
import 'intro_screens/intro_page_3.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}


// adding new file
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //controller for page track, on which page we are in
  PageController _controller = PageController();

  // keep track of if we are in the last page or not
  bool onLastPage = false;

  @override
  void initState() {
    super.initState();
    // Check if onboarding has been shown
    _checkIfOnboardingHasBeenShown();
  }

  // Method to check if onboarding has been shown
  _checkIfOnboardingHasBeenShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      // If onboarding has been shown, push the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      // If onboarding has not been shown, set the flag in shared preferences to true
      await prefs.setBool('seen', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),

        //dot indicator
        Container(
          alignment: const Alignment(0, 0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //skip
              GestureDetector(
                onTap: () {
                  _controller.jumpToPage(2);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 140, 0),
                    fontSize: 20,
                  ),
                ),
              ),

              //dot indicator
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  dotWidth: 12.0,
                  dotHeight: 12.0,
                  activeDotColor: Color.fromARGB(255, 255, 140, 0),
                ),
              ),

              //next or done
              onLastPage
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 140, 0),
                          fontSize: 20,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 140, 0),
                          fontSize: 20,
                        ),
                      ),
                    ),
            ],
          ),
        )
      ],
    ));
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: 70), //apply padding to some sides only
            child: Text('WELCOME \n To \n NEUROLYX',
                style: TextStyle(
                  color: Colors.black,
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
            'assets/images/workout1.svg',
            height: 250,
            width: 250,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed code here!
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            },
            label: const Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
                height: 0,
                fontSize: 25,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 255, 140, 0),
          ),
        ],
      )),
    );
  }
}

