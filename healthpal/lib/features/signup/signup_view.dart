import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/core/utils/app_images/app_images.dart';
import 'package:healthpal/features/login/login_view.dart';
import 'package:healthpal/features/profile/profile_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';
import 'package:healthpal/widgets/app_or_divider/app_divider.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController addNameController = TextEditingController();
  TextEditingController addEmailController = TextEditingController();
  TextEditingController addPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70, bottom: 5),
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
            const Padding(
              padding: EdgeInsets.only(top: 18.0, bottom: 2),
              child: Text(
                'Crear Cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            const Text(
              'Estamos aquí para ayudarte!',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormFieldCustom(
              controller: addNameController,
              hintText: 'Nombre',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.5),
                child: Image.asset(
                  LocalImages.icAcPerson,
                  height: 10,
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormFieldCustom(
              controller: addEmailController,
              hintText: 'Correo Electrónico',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.5),
                child: Image.asset(
                  LocalImages.icAcEmail,
                  height: 10,
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10,
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
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AppButtonView(
                text: 'Crear Cuenta',
                onTap: () {
                  Navigation.push(
                    context,
                    const ProfileView(),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const OrDivider(text: 'O'),
            const SizedBox(
              height: 20,
            ),
            AppButtonView(
              iconTextWidth: 10,
              isSizeBox: true,
              imgHeight: 25,
              isImage: true,
              image: LocalImages.icGoogleLogo,
              text: 'Continuar con Google',
              color: Colors.white,
              textColor: Colors.black,
              onTap: () {},
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(
              height: 25,
            ),
            RichText(
              text: TextSpan(
                text: '¿Ya tienes una cuenta? ',
                style: const TextStyle(
                  color: AppColors.silverColor,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Iniciar Sesión',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigation.pushReplacement(
                          context,
                          const SignInView(),
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
