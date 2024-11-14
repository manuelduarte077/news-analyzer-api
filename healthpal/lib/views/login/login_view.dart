import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/views/bottom_navigation_bar/bottom_navigation_bar_view.dart';
import 'package:healthpal/views/forgot_password/forgot_password_view.dart';
import 'package:healthpal/views/signup/signup_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';
import 'package:healthpal/widgets/app_or_divider/app_divider.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController addEmailController = TextEditingController();
  TextEditingController addPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
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
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                text: 'Daktar',
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.silverColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Lamara',
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, bottom: 2),
              child: Text(
                'Hola, Bienvenido!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Espero que estés bien.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            TextFormFieldCustom(
              controller: addEmailController,
              hintText: 'Correo Electrónico',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.5),
                child: Image.asset(
                  LocalImages.icAcPerson,
                  height: 10,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormFieldCustom(
              controller: addPasswordController,
              hintText: 'Contraseña',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.5),
                child: Image.asset(
                  LocalImages.icAcPassword,
                  height: 10,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AppButtonView(
                text: 'Iniciar sesión',
                onTap: () {
                  Navigation.removeAllPreviousAndPush(
                      context, const BottomNavigationBarView());
                },
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            const OrDivider(
              text: 'Or',
            ),
            const SizedBox(
              height: 23,
            ),
            AppButtonView(
              iconTextWidth: 10,
              isSizeBox: true,
              imgHeight: 25,
              isImage: true,
              image: LocalImages.icGoogleLogo,
              text: 'Iniciar sesión con Google',
              color: Colors.white,
              textColor: Colors.black,
              onTap: () {},
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 23),
            GestureDetector(
              onTap: () {
                Navigation.pushReplacement(
                  context,
                  const ForgotPasswordView(),
                );
              },
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            RichText(
              text: TextSpan(
                text: '¿No tienes una cuenta todavía? ',
                style: const TextStyle(
                  color: AppColors.silverColor,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Regístrate',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigation.pushReplacement(
                          context,
                          const SignUpView(),
                        );
                      },
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
