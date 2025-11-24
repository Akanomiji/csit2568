import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csit2568/splash_screen.dart';
import 'package:csit2568/user_model.dart'; // ต้อง import UserModel

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
