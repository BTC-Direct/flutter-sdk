


import 'package:btc_direct/src/presentation/config_packages.dart';

class CommonFontDimen extends StatelessWidget {
  final Widget child;
  const CommonFontDimen({required this.child,super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).size.width > 750 ? 1.22 : 0.95),
    child: child,
    );
  }
}
