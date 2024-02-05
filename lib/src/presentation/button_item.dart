

import 'package:btcdirect/src/presentation/config_packages.dart';

import 'app_colors.dart';

enum ButtonEnum { outline, filled, text }

class ButtonItem extends StatelessWidget {
  final String text;
  final Widget? icon;
  final double? width;
  final double? height;
  final double? borderRadius;
  double? fontSize;
  final VoidCallback? onPressed;
  FontStyle? fontStyle;
  late final ButtonEnum buttonType;
  final TextStyle? textStyle;
  MainAxisAlignment? mainAxisAlignment;
  final Color? bgColor;

  static const double _defaultRadius = 10;

  ButtonItem.outline({
    Key? key,
    required this.text,
    this.icon,
    this.borderRadius = _defaultRadius,
    this.width,
    this.textStyle,
    this.height,
    this.bgColor,
    required this.onPressed,
  }) : super(key: key) {
    buttonType = ButtonEnum.outline;
  }

  ButtonItem.filled({
    Key? key,
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
  }) : super(key: key) {
    buttonType = ButtonEnum.filled;
  }

  ButtonItem.text({
    Key? key,
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
  }) : super(key: key) {
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
              // boxShadow: [
              //   BoxShadow(
              //     color: Get.theme.shadowColor,
              //     spreadRadius: 1,
              //     blurRadius: 1.5,
              //     offset: const Offset(0.5, 0.5),
              //   ),
              // ],
              // color: bgColor ?? AppColors.transparent,
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
                    style: textStyle ,//?? Get.theme.textTheme.titleLarge!.copyWith(color: Get.theme.colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        );

      case ButtonEnum.filled:
        return GestureDetector(
          onTap: onPressed,
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
              color: bgColor ?? Theme.of(context).primaryColor,
            ),
            child:  Row(
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle ?? const TextStyle(),//?? Get.textTheme.titleLarge!.copyWith(color: AppColors.darkTextColor),
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
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: textStyle ?? TextStyle(
              fontSize: fontSize ?? 18,
              color: Theme.of(context).primaryColor,
              fontStyle: fontStyle ?? FontStyle.normal,
              decoration: TextDecoration.underline,
            )
          ),
        );
    }
  }
}
