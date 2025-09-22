import 'package:flutter/material.dart';
import 'package:waseembrayani/pages/user/home_screen.dart';
import 'package:waseembrayani/utils/consts.dart';

/// Onboarding Screen
/// ✅ Shows a welcome illustration with background + chef image
/// ✅ Includes title + subtitle
/// ✅ Provides "Get Started" button to navigate to HomeScreen
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 1: Get device screen size for responsive layout
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// Step 2: Background container with food illustration
          Container(
            height: size.height,
            width: size.width,
            color: imageBackground, // background color from consts.dart
            child: Image.asset(
              'assets/images/foodbackground.png',
              color: imageBackground2, // apply overlay tint color
              repeat: ImageRepeat.repeatY, // repeat vertically
            ),
          ),

          /// Step 3: Top illustration (Chef image)
          Positioned(
            top: 80, // place 80px from top
            left: 0,
            right: 0,
            child: Image.asset('assets/images/cheaf.png'),
          ),

          /// Step 4: Bottom container with white background
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
                    /// Step 4.1: Title text (black + red rich text)
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

                    /// Step 4.2: Subtitle text
                    Text(
                      textAlign: TextAlign.center,
                      'Our job is to filling your tummy with delisius food and fast delivery.',
                    ),

                    SizedBox(height: 20),

                    /// Step 4.3: "Get Started" button
                    MaterialButton(
                      onPressed: () {
                        // Navigate to HomeScreen when pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      color: red, // button color from consts
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
