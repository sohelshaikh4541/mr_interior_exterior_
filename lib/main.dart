import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interior_v_1/view/login/login.dart';
import 'package:interior_v_1/view/project/project_detail.dart';
import 'package:interior_v_1/view/splash/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interior & Exterior',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}


//Author :- Sohel Shaikh (Software)
//Author :- Sohel Shaikh (Developer)
