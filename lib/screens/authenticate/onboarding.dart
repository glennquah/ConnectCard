import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

class CustomOnboarding extends StatefulWidget {
  const CustomOnboarding({Key? key}) : super(key: key);

  @override
  State<CustomOnboarding> createState() => _CustomOnboardingState();
}

class _CustomOnboardingState extends State<CustomOnboarding> {
  late Material materialButton;
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xffFEAA1B),
          border: Border.all(
            width: 0.0,
            color: const Color(0xffFEAA1B),
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset('assets/logo/wifi_icon.png',
                    color: Colors.white),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'WI-FI Connection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please ensure that you are connected to Wi-Fi while using ConnectCard, as this will enable you to receive real-time data from your friends and allow the scanning of cards to be performed efficiently.',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xffFEAA1B),
          border: Border.all(
            width: 0.0,
            color: const Color(0xffFEAA1B),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 45.0,
                        vertical: 90.0,
                      ),
                      child: Image.asset('assets/logo/helpicon.png',
                          color: Colors.white),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Help Icon',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 45.0, vertical: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'If assistance is needed, simply click on the button located at the top-right corner of the screen for a detailed explanation',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xffFEAA1B),
          border: Border.all(
            width: 0.0,
            color: const Color(0xffFEAA1B),
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset('assets/logo/connectionicon.png',
                    color: Colors.white),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enjoy Connecting',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'With ConnectCard, Networking made easy.',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  SizedBox _skipButton({void Function(int)? setIndex}) {
    return SizedBox(
      width: 100, // Set the desired button width
      child: TextButton(
        onPressed: () {
          if (setIndex != null) {
            index = 2;
            setIndex(2);
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Skip',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  SizedBox get _signupButton {
    return SizedBox(
      width: 100, // Set the desired button width
      child: TextButton(
        onPressed: () {
          Navigator.pop(context); // Close the dialog
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Log in',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to ConnectCard'),
          backgroundColor: const Color(0xffFEAA1B),
        ),
        backgroundColor: const Color(0xffFEAA1B),
        body: Column(
          children: [
            Expanded(
              child: Onboarding(
                pages: onboardingPagesList,
                onPageChange: (int pageIndex) {
                  index = pageIndex;
                },
                startPageIndex: 0,
                footerBuilder: (context, dragDistance, pagesLength, setIndex) {
                  return ColoredBox(
                    color: const Color(0xffFEAA1B),
                    child: Padding(
                      padding: const EdgeInsets.all(45.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              pagesLength,
                              (pageIndex) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: pageIndex == index
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          index == pagesLength - 1
                              ? _signupButton
                              : _skipButton(setIndex: setIndex),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
