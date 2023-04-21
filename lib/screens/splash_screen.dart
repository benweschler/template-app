import 'package:flutter/material.dart';
import 'package:template_app/styles/styles.dart';
import 'package:template_app/widgets/loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingIndicator(Colors.red, size: Size.square(Insets.xl)),
      ),
    );
  }
}
