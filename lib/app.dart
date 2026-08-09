import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zyra/core/providers/theme_provider.dart';
import 'package:zyra/core/theme/app_theme.dart';
import 'package:zyra/features/auth/presentation/providers/auth_provider.dart';
import 'package:zyra/features/home/presentation/providers/home_provider.dart';
import 'package:zyra/features/sos/presentation/providers/sos_provider.dart';
import 'package:zyra/features/voice/presentation/providers/voice_provider.dart';
import 'package:zyra/features/location/presentation/providers/location_provider.dart';
import 'package:zyra/features/contacts/presentation/providers/contacts_provider.dart';
import 'routes/app_router.dart';

class ZyraApp extends StatelessWidget {
  const ZyraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SosProvider()),
        ChangeNotifierProvider(create: (_) => VoiceProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Zyra',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
