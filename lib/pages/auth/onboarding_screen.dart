import 'package:flutter/material.dart';
import 'package:waseembrayani/pages/screens/home_screen.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the device screen size for responsive UI
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background container with repeating image
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground, // background color from consts
            child: Image.asset(
              'assets/images/foodbackground.png',
              color: imageBackground2, // applies a tint color
              repeat: ImageRepeat.repeatY, // repeats vertically
            ),
          ),

          // Chef image positioned at the top
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/cheaf.png'),
          ),

          // Bottom container with white background
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // center vertically
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // center horizontally
                  children: [
                    // Title text with two colors (black + red)
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

                    // Subtitle text
                    Text(
                      textAlign: TextAlign.center,
                      'Our job is to filling your tummy with delisius food and fast delivery.',
                    ),

                    SizedBox(height: 20),

                    // "Get Started" button
                    MaterialButton(
                      onPressed: () {
                        // Navigate to HomeScreen when pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      color: red, // button background color
                      height: 65,
                      minWidth: 250,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // rounded edges
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

// Example of how you could create a custom clipper if needed
// class CustomClip extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     // Define custom clipping path here
//     throw UnimplementedError();
//   }
// }
