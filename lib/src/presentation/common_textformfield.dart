import 'package:btc_direct/src/presentation/config_packages.dart';

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
      this.onEditingComplete});

  final String? icon;
  final String? hintText;
  final String? errorText;
  final TextEditingController textEditingController;
  final bool? obscure;
  final String? Function(String? p1)? validator;
  final void Function()? onTap;
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

  /// Builds a [Column] widget containing a [TextFormField] with various configurations.
  ///
  /// The [TextFormField] is configured with the following properties:
  /// - [onChanged] callback is called when the text field's contents change.
  /// - [onTap] callback is called when the text field is tapped.
  /// - [keyBoardType] sets the keyboard type for the text field.
  /// - [inputFormatters] sets the input formatters for the text field.
  /// - [readOnly] sets whether the text field is read-only.
  /// - [textEditingController] sets the controller for the text field.
  /// - [obscureText] sets whether the text field's text is obscured.
  /// - [cursorColor] sets the color of the text field's cursor.
  /// - [textCapitalization] sets the capitalization style of the text field.
  /// - [maxLines] sets the maximum number of lines for the text field.
  /// - [onEditingComplete] callback is called when the text field's editing is complete.
  /// - [validator] sets the validation callback for the text field.
  /// - [decoration] sets the decoration for the text field.
  /// - The decoration includes the following properties:
  ///     - [border] sets the border for the text field when it is not focused.
  ///     - [disabledBorder] sets the border for the text field when it is disabled.
  ///     - [enabledBorder] sets the border for the text field when it is enabled.
  ///     - [focusedBorder] sets the border for the text field when it is focused.
  ///     - [focusedErrorBorder] sets the border for the text field when it is focused and has an error.
  ///     - [hintText] sets the hint text for the text field.
  ///     - [prefixIcon] sets the prefix icon for the text field.
  ///     - [errorText] sets the error text for the text field.
  ///     - [errorStyle] sets the style for the error text.
  ///     - [suffixIcon] sets the suffix icon for the text field.
  ///     - [errorBorder] sets the border for the text field when it has an error.
  ///     - [hintStyle] sets the style for the hint text.
  ///     - [contentPadding] sets the padding for the text field's content.
  ///
  /// Returns a [Column] widget containing the [TextFormField].
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            onChanged: onChanged,
            onTap: onTap,
            keyboardType: keyBoardType,
            inputFormatters: inputFormatters,
            readOnly: readOnly ?? false,
            controller: textEditingController,
            obscureText: obscure ?? false,
            cursorColor: CommonColors.blueColor,
            textCapitalization: textCapitalization,
            maxLines: maxlines ?? 1,
            onEditingComplete: onEditingComplete,
            validator: validator,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: CommonColors.blueColor)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: CommonColors.greyColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: CommonColors.greyColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: CommonColors.blueColor)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: CommonColors.redColor)),
                //focusColor: AppColors.darkTextColor,
                hintText: hintText,
                prefixIcon: prefix,
                errorText: errorText,
                errorStyle: const TextStyle(
                    fontSize: 14,
                    height: 0.5,
                    color: CommonColors.redColor,
                    fontFamily: 'TextaAlt',
                    package: "btc_direct",
                    fontWeight: FontWeight.w500),
                suffixIcon: suffix,
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: CommonColors.redColor)),
                hintStyle: hintTextStyle,
                //?? Get.textTheme.bodyLarge!.copyWith(color: Get.theme.hintColor),
                contentPadding: const EdgeInsets.only(left: 12))),
      ],
    );
  }
}

class CustomBoxShadow extends BoxShadow {
/*  @override
  final BlurStyle blurStyle;*/

  const CustomBoxShadow({
    super.color,
    super.offset,
    super.blurRadius,
    // this.blurStyle = BlurStyle.normal,
  });

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
