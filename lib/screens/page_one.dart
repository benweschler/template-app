import 'package:flutter/material.dart';
import 'package:template_app/widgets/custom_scaffold.dart';

class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(child: Center(child: Text("Page One")));
  }
}

