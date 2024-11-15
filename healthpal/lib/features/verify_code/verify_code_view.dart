import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthpal/core/navigation/navigator.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';
import 'package:healthpal/core/utils/app_images/app_images.dart';
import 'package:healthpal/features/create_password/create_new_password_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({super.key});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Widget _buildPasswordBox(int index) {
    return Expanded(
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          obscureText: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(fontSize: 24),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < focusNodes.length - 1) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0, bottom: 2),
              child: Text(
                'Verificar Código',
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
              'Ingrese el código \n que le acabamos de enviar a su correo electrónico registrado',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) => _buildPasswordBox(index)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AppButtonView(
                text: 'Verificar',
                onTap: () {
                  Navigation.pushReplacement(
                    context,
                    const CreateNewPasswordView(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: '¿No recibiste el código?',
                style: const TextStyle(color: AppColors.silverColor),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Resend',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigation.push(
                          context,
                          VerifyCodeView(),
                        );
                      },
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
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
