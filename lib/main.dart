import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'constants/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configurações de localização
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português (Brasil)
        Locale('en', ''),   // Inglês
      ],

      // Título do app
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },

      // Tema
      theme: AppTheme.lightTheme,

      // Remove banner de debug
      debugShowCheckedModeBanner: false,

      // Tela inicial
      home: const HomeScreen(),
    );
  }
}
