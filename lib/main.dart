import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'state/app_state.dart';
import 'screens/main_navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EtmaenanApp());
}

/// Root application widget for "اطمئنان" / "Etmaenan".
/// Initializes the shared in-memory AppState and configures bilingual localizations.
class EtmaenanApp extends StatefulWidget {
  const EtmaenanApp({super.key});

  @override
  State<EtmaenanApp> createState() => _EtmaenanAppState();
}

class _EtmaenanAppState extends State<EtmaenanApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    // Initialize in-memory state with Arabic as the default language
    _appState = AppState();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      appState: _appState,
      child: ListenableBuilder(
        listenable: _appState,
        builder: (context, _) {
          return MaterialApp(
            title: _appState.isArabic ? 'اطمئنان' : 'Etmaenan',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            // Dynamic locale (Arabic by default, switches to English on demand)
            locale: _appState.locale,
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // Direct access to the new Main Navigation Shell (Home screen)
            home: const MainNavigationShell(),
          );
        },
      ),
    );
  }
}
