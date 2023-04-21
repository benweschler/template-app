import 'package:flutter/material.dart';
import 'package:template_app/widgets/custom_scaffold.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(child: Center(child: Text("Page Two")));
  }
}
