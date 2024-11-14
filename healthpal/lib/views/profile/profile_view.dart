import 'package:flutter/material.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';
import 'package:healthpal/widgets/app_text_from_field/app_text_from_field_view.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController editNameController = TextEditingController();
  TextEditingController editNicknameController = TextEditingController();
  TextEditingController editEmailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  final List<String> genderItems = ['Male', 'Female', 'Other'];

  String? selectedValue;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill Your Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      maxRadius: 60,
                      child: Icon(
                        Icons.person_4_outlined,
                        color: Colors.grey.shade500,
                        size: 80,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 121,
                    child: Image.asset(
                      LocalImages.icProfileEditLogo,
                      height: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormFieldCustom(
                controller: editNameController,
                hintText: 'Michael Jordan',
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormFieldCustom(
                controller: editNicknameController,
                hintText: 'Nickname',
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormFieldCustom(
                controller: editEmailController,
                hintText: 'name@example.com',
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () async {
                  await _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormFieldCustom(
                    controller: dateController,
                    hintText: 'Date of Birth',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.5),
                      child: Image.asset(
                        LocalImages.icDateLogo,
                        height: 10,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.silverColor, width: 0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      isCollapsed: true,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    value: selectedValue,
                    hint: const Text(
                      'Gender',
                      style: TextStyle(
                        color: AppColors.silverColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    items: genderItems.map(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    icon: Image.asset(
                      LocalImages.icDropDownLogo,
                    ),
                    onChanged: (newValue) {
                      setState(
                        () {
                          selectedValue = newValue;
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              AppButtonView(
                onTap: () {
                  _dialogBuilder(context);
                },
                text: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      });
    }
  }

  Future<void> _dialogBuilder(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                child: Image.asset(
                  LocalImages.icCongratulationsLogo,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your account is ready to use. You will be redirected to the Home Page in a few seconds...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: const [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                width: 50,
                child: LoadingIndicator(
                    indicatorType: Indicator.ballRotateChase,
                    colors: [Colors.black, Colors.white],
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }
}
