import 'package:flutter/material.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/core/utils/app_images/app_images.dart';
import 'package:healthpal/core/utils/app_strings/app_strings.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class AppBannerView extends StatefulWidget {
  const AppBannerView({super.key});

  @override
  State<AppBannerView> createState() => _AppBannerViewState();
}

class _AppBannerViewState extends State<AppBannerView> {
  final PageController _controller = PageController();
  Timer? _timer;

  final List<Map<String, dynamic>> bannerImgDetail = [
    {
      'image': LocalImages.icBanner,
      'title': AppStrings.bannerTitle,
      'description': AppStrings.bannerDescription,
    },
    {
      'image': LocalImages.icBanner,
      'title': AppStrings.bannerTitle,
      'description': AppStrings.bannerDescription,
    },
    {
      'image': LocalImages.icBanner,
      'title': AppStrings.bannerTitle,
      'description': AppStrings.bannerDescription,
    },
    {
      'image': LocalImages.icBanner,
      'title': AppStrings.bannerTitle,
      'description': AppStrings.bannerDescription,
    },
    {
      'image': LocalImages.icBanner,
      'title': AppStrings.bannerTitle,
      'description': AppStrings.bannerDescription,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      int nextPage = (_controller.page?.round() ?? 0) + 1;

      if (nextPage == bannerImgDetail.length) {
        nextPage = 0;
      }

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 175,
          width: double.infinity,
          child: PageView.builder(
            padEnds: true,
            controller: _controller,
            itemCount: bannerImgDetail.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(bannerImgDetail[index]['image']),
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.1),
                      BlendMode.softLight,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bannerImgDetail[index]['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bannerImgDetail[index]['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150, left: 125),
          child: SmoothPageIndicator(
            controller: _controller,
            count: bannerImgDetail.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 6,
              dotWidth: 8,
              expansionFactor: 2.5,
              spacing: 6,
              activeDotColor: AppColors.whiteColor,
              dotColor: Color(0xFF9B9B9B),
            ),
          ),
        ),
      ],
    );
  }
}
