import 'package:flutter/material.dart';
import 'package:zyra/features/auth/presentation/screens/splash_screen.dart';
import 'package:zyra/features/auth/presentation/screens/login_screen.dart';
import 'package:zyra/features/auth/presentation/screens/register_screen.dart';
import 'package:zyra/features/home/presentation/screens/home_screen.dart';
import 'package:zyra/features/sos/presentation/screens/sos_screen.dart';
import 'package:zyra/features/voice/presentation/screens/voice_settings_screen.dart';
import 'package:zyra/features/location/presentation/screens/location_screen.dart';
import 'package:zyra/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:zyra/features/contacts/presentation/screens/add_contact_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String sos = '/sos';
  static const String voiceSettings = '/voice-settings';
  static const String location = '/location';
  static const String contacts = '/contacts';
  static const String addContact = '/add-contact';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case sos:
        return MaterialPageRoute(
          builder: (_) => const SosScreen(),
          settings: settings,
        );
      case voiceSettings:
        return MaterialPageRoute(
          builder: (_) => const VoiceSettingsScreen(),
          settings: settings,
        );
      case location:
        return MaterialPageRoute(
          builder: (_) => const LocationScreen(),
          settings: settings,
        );
      case contacts:
        return MaterialPageRoute(
          builder: (_) => const ContactsScreen(),
          settings: settings,
        );
      case addContact:
        return MaterialPageRoute(
          builder: (_) => const AddContactScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
