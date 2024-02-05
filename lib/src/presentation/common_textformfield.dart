

import 'package:btcdirect/src/presentation/app_colors.dart';
import 'package:btcdirect/src/presentation/config_packages.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField(
      {super.key,
      this.icon,
      this.hintText,
      this.errorText,
      this.textCapitalization = TextCapitalization.none,
      required this.textEditingController,
      this.obscure,
      this.validator,
      this.onTap,
      this.helpertext,
      this.prefix,
      this.suffix,
      this.hintTextStyle,
      this.maxlines,
      this.isTooltip,
      this.readOnly,
      this.errorStyle,
      this.keyBoardType,
      this.inputFormatters,
      this.onChanged,
      this.onEditingComplete
      });

  final String? icon;
  final String? hintText;
  final String? errorText;
  final TextEditingController textEditingController;
  final bool? obscure;
  final String? Function(String? p1)? validator;
  final Function? onTap;
  final String? helpertext;
  final Widget? prefix;
  final Widget? suffix;
  final TextStyle? hintTextStyle;
  final int? maxlines;
  final bool? isTooltip;
  final bool? readOnly;
  final TextStyle? errorStyle;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            onChanged: onChanged,
            keyboardType: keyBoardType,
            inputFormatters: inputFormatters,
            readOnly: readOnly ?? false,
            controller: textEditingController,
            obscureText: obscure ?? false,
            //cursorColor: Get.theme.iconTheme.color,
            textCapitalization: textCapitalization,
            maxLines: maxlines ?? 1,
            onEditingComplete: onEditingComplete,
            //style: Get.textTheme.bodyLarge!.copyWith(color: Get.theme.iconTheme.color),
            validator: validator,
            decoration: InputDecoration(
                //fillColor: Get.theme.scaffoldBackgroundColor,
                //filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.blueColor)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.greyColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.greyColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.blueColor)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.redColor)),
                //focusColor: AppColors.darkTextColor,
                hintText: hintText,
                prefixIcon: prefix,
                errorText: errorText,
                errorStyle: const TextStyle(fontSize: 14,height: 0.5,color: AppColors.redColor, fontFamily: 'TextaAlt', fontWeight: FontWeight.w500),
                suffixIcon: suffix,
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.redColor)),
                hintStyle: hintTextStyle ,//?? Get.textTheme.bodyLarge!.copyWith(color: Get.theme.hintColor),
                contentPadding: const EdgeInsets.only(left:12))),
      ],
    );
  }
}

class CustomBoxShadow extends BoxShadow {
  @override
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
