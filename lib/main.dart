import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bizeval/screens/home_screen.dart';
import 'package:bizeval/screens/camera_placeholder.dart';
import 'package:bizeval/screens/upload_placeholder.dart';
import 'package:bizeval/screens/analysis_screen.dart';
import 'package:bizeval/screens/login_screen.dart';
import 'package:bizeval/providers/auth_provider.dart';
import 'package:bizeval/providers/image_provider.dart';
import 'package:bizeval/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ImageDataProvider()),
      ],
      child: MaterialApp(
        title: 'BizEval',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        //darkTheme: AppTheme.darkTheme,
        //themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/camera': (context) => const CameraPlaceholder(),
          '/upload': (context) => const UploadPlaceholder(),
          '/analysis': (context) => const AnalysisScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}