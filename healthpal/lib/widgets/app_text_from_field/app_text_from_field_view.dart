import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';

class TextFormFieldCustom extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? titleName;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool? obscureText;
  final Function? callBackTextFormField;
  final Function? callBackOnChange;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixConstraints;
  final bool? readOnly;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? isTitleName;
  final int? maxLines;
  final BorderRadius? disabledBorderRadius;
  final BorderRadius? focusedBorderRadius;
  final BorderRadius? enabledBorderRadius;

  const TextFormFieldCustom({
    super.key,
    this.controller,
    this.hintText,
    this.textInputAction,
    this.textInputType,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.callBackOnChange,
    this.callBackTextFormField,
    this.fillColor,
    this.maxLength,
    this.prefixIconConstraints,
    this.suffixConstraints,
    this.inputFormatters,
    this.enabled,
    this.titleName,
    this.isTitleName,
    this.maxLines,
    this.disabledBorderRadius,
    this.focusedBorderRadius,
    this.enabledBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          child: TextFormField(
            maxLines: maxLines,
            controller: controller,
            enabled: enabled ?? true,
            readOnly: readOnly ?? false,
            textInputAction: textInputAction ?? TextInputAction.next,
            keyboardType: textInputType ?? TextInputType.text,
            cursorColor: Colors.black,
            obscuringCharacter: '*',
            maxLength: maxLength,
            obscureText: obscureText ?? false,
            inputFormatters: inputFormatters ?? [],
            onChanged: (value) {
              if (callBackOnChange != null) callBackOnChange!(value);
            },
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: const EdgeInsets.only(
                left: 24,
                right: 18,
                top: 16,
                bottom: 0,
              ),
              hintText: hintText ?? 'HintText',
              filled: true,
              fillColor: fillColor ?? Colors.transparent,
              hintStyle: const TextStyle(
                color: AppColors.silverColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius:
                    disabledBorderRadius ?? BorderRadius.circular(12.0),
                borderSide:
                    const BorderSide(color: AppColors.silverColor, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    focusedBorderRadius ?? BorderRadius.circular(12.0),
                borderSide:
                    const BorderSide(color: AppColors.silverColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    enabledBorderRadius ?? BorderRadius.circular(12.0),
                borderSide:
                    const BorderSide(color: AppColors.silverColor, width: 0.5),
              ),
              prefixIcon: prefixIcon,
              prefixIconConstraints: prefixIconConstraints,
              suffixIcon: suffixIcon,
              suffixIconConstraints: suffixConstraints,
            ),
            onTap: () {
              if (callBackTextFormField != null) callBackTextFormField!();
            },
          ),
        ),
      ],
    );
  }
}
