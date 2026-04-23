import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/app_text_style.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    this.secured = false,
    this.keyboardType = TextInputType.emailAddress,
    this.validators,
    this.maxLength,
    this.focusNode,
    this.onChanged,
    this.hintStyle,
    this.prefixIcon,
    this.searchTapped,
    this.child, // ضفنا الـ child هنا
  });

  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final void Function(String)? searchTapped;
  final TextStyle? hintStyle;
  final bool secured;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validators;
  final int? maxLength;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final Widget? child; // تعريف الـ child

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obSecure = true;
  late FocusNode _effectiveFocusNode;

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _effectiveFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _effectiveFocusNode.dispose();
    }
    super.dispose();
  }

  void toggle() {
    setState(() {
      obSecure = !obSecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(8.r);
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.primaryBeig),
    );
    OutlineInputBorder focusBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.primaryBrown),
    );
    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: Colors.redAccent),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTextStyle.hintStyle.copyWith(
              color: AppColors.primaryBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        // التعديل هنا: لو بعتنا child اعرضه، غير كدة اعرض الـ TextFormField العادي
        widget.child ??
            TextFormField(
              onFieldSubmitted: widget.searchTapped,
              onChanged: widget.onChanged,
              maxLength: widget.maxLength,
              focusNode: _effectiveFocusNode,
              validator: widget.validators,
              keyboardType: widget.keyboardType,
              cursorColor: AppColors.primaryBrown,
              cursorHeight: 20.h,
              cursorWidth: 2.w,
              controller: widget.controller,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              obscureText: widget.secured && obSecure,
              decoration: InputDecoration(
                counterText: "",
                suffixIcon: widget.secured
                    ? Padding(
                        padding: EdgeInsets.all(16.r),
                        child: InkWell(
                          onTap: toggle,
                          child: obSecure
                              ? SvgPicture.asset(
                                  "assets/icons/visibilite_off.svg",
                                  width: 15.w,
                                )
                              : SvgPicture.asset(
                                  "assets/icons/Visibility.svg",
                                  width: 15.w,
                                ),
                        ),
                      )
                    : null,
                hintText: _effectiveFocusNode.hasFocus ? "" : widget.hintText,
                hintStyle: widget.hintStyle ?? AppTextStyle.hintStyle,
                fillColor: AppColors.textFieldBackground,
                filled: true,
                errorStyle: AppTextStyle.errorStyle,
                enabledBorder: border,
                focusedBorder: focusBorder,
                errorBorder: errorBorder,
                focusedErrorBorder: focusBorder,
                prefixIcon: widget.prefixIcon,
              ),
            ),
      ],
    );
  }
}