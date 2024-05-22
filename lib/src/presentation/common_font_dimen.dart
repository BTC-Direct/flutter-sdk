import 'package:btc_direct/src/presentation/config_packages.dart';

class CommonFontDimen extends StatelessWidget {
  final Widget child;
  const CommonFontDimen({required this.child, super.key});

  @override

  /// Builds a widget based on the given [context].
  ///
  /// This function calculates the `textScaleFactor` based on the width of the screen.
  /// If the width is greater than 750, it sets the `textScaleFactor` to 1.22, otherwise it sets it to 0.95.
  /// It then creates a new `MediaQuery` widget with the updated `textScaleFactor` and the original `context`.
  /// The `child` widget is passed as a child to the `MediaQuery` widget.
  ///
  /// Parameters:
  /// - `context`: The build context used to access the current widget's configuration.
  ///
  /// Returns:
  /// A `Widget` that wraps the `child` widget with a `MediaQuery` widget that updates the text scale factor.
  Widget build(BuildContext context) {
    double textScaleFactor =
        MediaQuery.of(context).size.width > 750 ? 1.22 : 0.95;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScaleFactor)),
      child: child,
    );
  }
}
