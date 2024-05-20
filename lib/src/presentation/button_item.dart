

import 'package:btc_direct/src/presentation/config_packages.dart';

enum ButtonEnum { outline, filled, text }
//ignore: must_be_immutable
class CommonButtonItem extends StatelessWidget {
  final String text;
  final Widget? icon;
  final double? width;
  final double? height;
  final double? borderRadius;
  double? fontSize;
  final Function()? onPressed;
  FontStyle? fontStyle;
  late final ButtonEnum buttonType;
  final TextStyle? textStyle;
  MainAxisAlignment? mainAxisAlignment;
  final Color? bgColor;
  final bool isEnabled;

  static const double _defaultRadius = 10;

  CommonButtonItem.outline({
    super.key,
    required this.text,
    this.icon,
    this.borderRadius = _defaultRadius,
    this.width,
    this.textStyle,
    this.height,
    this.bgColor,
    required this.onPressed,
    this.isEnabled = true,
  }) {
    buttonType = ButtonEnum.outline;
  }

  CommonButtonItem.filled({
    super.key,
    required this.text,
    this.icon,
    this.width,
    this.borderRadius = _defaultRadius,
    this.fontSize,
    this.textStyle,
    this.height,
    this.mainAxisAlignment,
    this.bgColor,
    required this.onPressed,
    this.isEnabled = true,
  }) {
    buttonType = ButtonEnum.filled;
  }

  CommonButtonItem.text({
    super.key,
    required this.text,
    this.icon,
    this.fontStyle,
    this.width,
    this.fontSize,
    this.borderRadius = _defaultRadius,
    this.textStyle,
    this.height,
    this.bgColor,
    required this.onPressed,
    this.isEnabled = true,
  }) {
    buttonType = ButtonEnum.text;
  }

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonEnum.outline:
        return GestureDetector(
          onTap: onPressed,
          child: Container(
            height: height ?? 60,
            width: width ?? 470,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 15),
              border: Border.all(color: bgColor ?? Theme.of(context).primaryColor, width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: icon == null ? MainAxisAlignment.center : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon == null ? const SizedBox.shrink() : const SizedBox(width: 8),
                icon == null ? const SizedBox.shrink() : icon!,
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle, //?? Get.theme.textTheme.titleLarge!.copyWith(color: Get.theme.colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        );

      case ButtonEnum.filled:
        return GestureDetector(
          onTap: isEnabled ? onPressed : null,
          child: Container(
            height: height ?? 60,
            width: width ?? 470,
            decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: bgColor ?? Colors.black12 ,//?? Get.theme.primaryColor,
              //     spreadRadius: 0,
              //     blurRadius: 5,
              //     offset: const Offset(-1, 2),
              //   )
              // ],
              borderRadius: BorderRadius.circular(borderRadius ?? 15),
              color: isEnabled ? (bgColor ?? Theme.of(context).primaryColor) : Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle ?? const TextStyle(), //?? Get.textTheme.titleLarge!.copyWith(color: AppColors.darkTextColor),
                  ),
                ),
                icon == null ? const SizedBox.shrink() : const SizedBox(width: 8),
                icon == null ? const SizedBox.shrink() : icon!
              ],
            ),
          ),
        );

      case ButtonEnum.text:
        return TextButton(
          key: key,
          onPressed: onPressed,
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              style: textStyle ??
                  TextStyle(
                    fontSize: fontSize ?? 18,
                    color: Theme.of(context).primaryColor,
                    fontStyle: fontStyle ?? FontStyle.normal,
                    decoration: TextDecoration.underline,
                  )),
        );
    }
  }
}
