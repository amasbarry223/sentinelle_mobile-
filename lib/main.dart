import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive status bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const SentinelleApp(),
    ),
  );
}

class SentinelleApp extends StatelessWidget {
  const SentinelleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentinelle Mali',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        // On widescreen desktop, present as a sleek mobile device frame
        if (mediaQuery.size.width > 520) {
          return Container(
            color: const Color(0xFF0F172A),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420, maxHeight: 920),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 50,
                    spreadRadius: 8,
                    offset: const Offset(0, 16),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF334155),
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(37),
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    size: const Size(420, 880),
                  ),
                  child: child ?? const SizedBox(),
                ),
              ),
            ),
          );
        }
        return child ?? const SizedBox();
      },
      home: const SplashScreen(),
    );
  }
}
