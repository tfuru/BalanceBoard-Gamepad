import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/gamepad_provider.dart';
import 'views/dashboard_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GamepadProvider(),
      child: const BalanceBoardApp(),
    ),
  );
}

class BalanceBoardApp extends StatelessWidget {
  const BalanceBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BalanceBoard Gamepad Relay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const DashboardView(),
    );
  }
}
