import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:balance_board_app/l10n/app_localizations.dart';
import 'package:balance_board_app/models/app_config.dart';
import 'package:balance_board_app/providers/gamepad_provider.dart';
import 'package:balance_board_app/views/components/output_status_card.dart';

void main() {
  testWidgets('OutputStatusCard renders mode labels correctly', (WidgetTester tester) async {
    final provider = GamepadProvider();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ChangeNotifierProvider<GamepadProvider>.value(
            value: provider,
            child: const OutputStatusCard(),
          ),
        ),
      ),
    );

    // Default mode is virtualGamepad
    expect(find.textContaining('仮想ゲームパッド'), findsWidgets);

    // Switch to WASD mode
    provider.setOutputMode(OutputMode.keyboardWasd);
    await tester.pump();

    expect(find.textContaining('WASD キーボード'), findsWidgets);
    expect(find.text('W'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('S'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);

    // Switch to OSC mode
    provider.setOutputMode(OutputMode.oscInputController);
    await tester.pump();

    expect(find.textContaining('OSC as Input Controller'), findsWidgets);
    expect(find.textContaining('/input/Horizontal'), findsOneWidget);
    expect(find.textContaining('/input/Vertical'), findsOneWidget);
  });
}
