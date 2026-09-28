import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const ObsessRunningApp());
}

class ObsessRunningApp extends StatelessWidget {
  const ObsessRunningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obsess Running',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),

      // Tambahkan routes di sini
      routes: {
        '/login': (context) => const LoginScreen(),
      },

      home: const LoginScreen(),
    );
  }
}
