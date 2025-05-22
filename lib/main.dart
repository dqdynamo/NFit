import 'package:diploma/services/device_service.dart';
import 'package:diploma/services/health_service.dart';
import 'package:diploma/services/sleep_tracker_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:diploma/pages/Authentication/splash_screen.dart';
import 'package:diploma/pages/Authentication/login_screen.dart';
import 'package:diploma/pages/Main/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:diploma/services/activity_tracker_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('ru', null);

  // Больше не нужно вызывать configure(), он отсутствует в новой версии health
  // final healthService = HealthService();
  // await healthService.configure();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ActivityTrackerService()),
        ChangeNotifierProvider(create: (_) => SleepTrackerService()),
        ChangeNotifierProvider(create: (_) => DeviceService()),
      ],
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
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const BottomNavBarScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
      ],
    );
  }
}
