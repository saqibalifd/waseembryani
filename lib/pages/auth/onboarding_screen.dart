import 'package:flutter/material.dart';
import 'package:waseembrayani/pages/screens/home_screen.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground,
            child: Image.asset(
              'assets/images/foodbackground.png',
              color: imageBackground2,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/cheaf.png'),
          ),
          Align(
            alignment: Alignment.bottomCenter,

            child: Container(
              height: 300,
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'The Fastest In Delivery',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' Food',
                            style: TextStyle(
                              color: red,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      textAlign: TextAlign.center,
                      'Our job is to filling your tummy with delisius food and fast delivery.',
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      color: red,
                      height: 65,
                      minWidth: 250,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// class CustomClip extends CustomClipper <Path> {
  
//   @override
//   Path getClip(Size size) {
//     // TODO: implement getClip
//     throw UnimplementedError();
//   }
// }