import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_watch/main_menu.dart';

void main() {
  // Asegurarse de que los widgets estén inicializados antes de configurar la orientación
  WidgetsFlutterBinding.ensureInitialized();
  // Forzar la orientación vertical, ideal para un reloj
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simón Wear OS',
      theme: ThemeData.dark().copyWith(
        // Un tema oscuro es perfecto para pantallas OLED de wearables
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.tealAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainMenu(),
    );
  }
}
