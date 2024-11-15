import 'package:flutter/material.dart';
import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/core/utils/app_images/app_images.dart';
import 'package:healthpal/features/verify_code/verify_code_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController addEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20) +
            const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35, bottom: 5),
              child: Center(
                child: Image.asset(
                  LocalImages.appLogo,
                  height: 70,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            RichText(
              text: const TextSpan(
                text: 'Health',
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.silverColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Pal',
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, bottom: 2),
              child: Text(
                'Forget Password?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enter your Email, we will send you a verification\ncode.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            TextFormFieldCustom(
              controller: addEmailController,
              hintText: 'Your Email',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.5),
                child: Image.asset(
                  LocalImages.icAcEmail,
                  height: 10,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AppButtonView(
                text: 'Send Code',
                onTap: () {
                  Navigation.push(
                    context,
                    const VerifyCodeView(),
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
