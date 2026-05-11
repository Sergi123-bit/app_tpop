import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/auth/auth_screens.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const TPopApp(),
    ),
  );
}

class TPopApp extends StatelessWidget {
  const TPopApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha el tema en tiempo real
    final temaOscuro = context.watch<AppState>().temaOscuro;

    return MaterialApp(
      title: 'T-POP',
      debugShowCheckedModeBanner: false,
      // ✅ Cambia entre claro y oscuro según el estado
      theme:     AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: temaOscuro ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/':         (_) => const _AuthGate(),
        '/login':    (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home':     (_) => const MainShell(),
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AppState>().isLoggedIn;
    return loggedIn ? const MainShell() : const LoginScreen();
  }
}