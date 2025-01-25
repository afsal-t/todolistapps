import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:todolistapp/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCp3ReIDYBGWSYeQLQuvkO8s92ptn5wp8U",
      appId: "1:502257668616:android:811fd8b78515cf390db7bd",
      messagingSenderId: "",
      projectId: "todolistapp-cd1d8",
      storageBucket: "todolistapp-cd1d8.firebasestorage.app",
    ),
  );

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}
