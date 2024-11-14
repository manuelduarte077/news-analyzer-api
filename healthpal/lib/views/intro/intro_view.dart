import 'package:flutter/material.dart';
import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/utils/app_strings/app_strings.dart';
import 'package:healthpal/views/login/login_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final List<Map<String, dynamic>> introImgDetail = [
    {
      'image': LocalImages.icIntroImgFirst,
      'title': AppStrings.firstTitle,
      'description': AppStrings.firstDescription,
    },
    {
      'image': LocalImages.icIntroImgSecond,
      'title': AppStrings.secondTitle,
      'description': AppStrings.secondDescription,
    },
    {
      'image': LocalImages.icSBottomThird,
      'title': AppStrings.thirdTitle,
      'description': AppStrings.thirdDescription,
    },
  ];

  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_controller.page?.toInt() == introImgDetail.length - 1) {
      Navigation.push(
        context,
        const SignInView(),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: introImgDetail.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset(introImgDetail[index]['image']),
                    const SizedBox(height: 10),
                    Text(
                      introImgDetail[index]['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        introImgDetail[index]['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30) +
                const EdgeInsets.only(bottom: 14),
            child: AppButtonView(
              text: 'Siguiente',
              onTap: _onNextPressed,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SmoothPageIndicator(
              controller: _controller, // PageController
              count: introImgDetail.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 10,
                expansionFactor: 2.5,
                spacing: 8,
                activeDotColor: Color(0xFF26232F),
                dotColor: Color(0xFF9B9B9B),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: InkWell(
              onTap: () {
                Navigation.push(
                  context,
                  const SignInView(),
                );
              },
              child: const Text(
                'Omitir',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
