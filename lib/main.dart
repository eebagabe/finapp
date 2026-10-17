import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const FinApp());
}

class FinApp extends StatelessWidget {
  const FinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const Scaffold(body: Center(child: Text('FinApp'))),
    );
  }
}
