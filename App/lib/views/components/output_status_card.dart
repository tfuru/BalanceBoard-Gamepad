import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../models/app_config.dart';
import '../../providers/gamepad_provider.dart';

/// 選択中出力モードの動作・キー押下・送信パラメータをリアルタイム監視・確認できるモニターカード
class OutputStatusCard extends StatelessWidget {
  const OutputStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<GamepadProvider>(context);
    final mode = provider.config.outputMode;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getModeIcon(mode),
                size: 16,
                color: _getModeColor(mode),
              ),
              const SizedBox(width: 8),
              Text(
                'Monitor (${mode.getLocalizedLabel(l10n)})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildModeContent(context, provider, mode, l10n),
        ],
      ),
    );
  }

  IconData _getModeIcon(OutputMode mode) {
    switch (mode) {
      case OutputMode.virtualGamepad:
        return Icons.sports_esports;
      case OutputMode.oscInputController:
        return Icons.sensors;
      case OutputMode.keyboardWasd:
        return Icons.keyboard;
      case OutputMode.none:
        return Icons.block;
    }
  }

  Color _getModeColor(OutputMode mode) {
    switch (mode) {
      case OutputMode.virtualGamepad:
        return const Color(0xFF38BDF8);
      case OutputMode.oscInputController:
        return const Color(0xFF10B981);
      case OutputMode.keyboardWasd:
        return const Color(0xFFF59E0B);
      case OutputMode.none:
        return Colors.grey;
    }
  }

  Widget _buildModeContent(BuildContext context, GamepadProvider provider, OutputMode mode, AppLocalizations l10n) {
    switch (mode) {
      case OutputMode.keyboardWasd:
        return _buildWasdMonitor(provider);
      case OutputMode.oscInputController:
        return _buildOscMonitor(provider);
      case OutputMode.virtualGamepad:
        return _buildGamepadMonitor(provider);
      case OutputMode.none:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              l10n.modeNoneDesc,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        );
    }
  }

  /// WASD キーボード押下モニター
  Widget _buildWasdMonitor(GamepadProvider provider) {
    final kb = provider.keyboardService;
    final isJumping = provider.isJumping;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 44),
            _buildKeyTile('W', kb.isWPressed),
            const SizedBox(width: 44),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeyTile('A', kb.isAPressed),
            const SizedBox(width: 6),
            _buildKeyTile('S', kb.isSPressed),
            const SizedBox(width: 6),
            _buildKeyTile('D', kb.isDPressed),
          ],
        ),
        const SizedBox(height: 6),
        _buildSpaceKeyTile(isJumping),
        const SizedBox(height: 8),
        Text(
          _getActiveKeyText(kb, isJumping),
          style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSpaceKeyTile(bool isPressed) {
    return Container(
      width: 130,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isPressed ? const Color(0xFFEC4899) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPressed ? const Color(0xFFF472B6) : Colors.white24,
          width: isPressed ? 2 : 1,
        ),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: const Color(0xFFEC4899).withAlpha(128),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: Text(
        'Space (Jump)',
        style: TextStyle(
          color: isPressed ? Colors.white : Colors.white60,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildKeyTile(String keyLabel, bool isPressed) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isPressed ? const Color(0xFFF59E0B) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPressed ? const Color(0xFFFBBF24) : Colors.white24,
          width: isPressed ? 2 : 1,
        ),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withAlpha(128),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: Text(
        keyLabel,
        style: TextStyle(
          color: isPressed ? Colors.black : Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  String _getActiveKeyText(dynamic kb, bool isJumping) {
    final activeKeys = <String>[];
    if (kb.isWPressed) activeKeys.add('W');
    if (kb.isAPressed) activeKeys.add('A');
    if (kb.isSPressed) activeKeys.add('S');
    if (kb.isDPressed) activeKeys.add('D');
    if (isJumping) activeKeys.add('Space (Jump)');

    if (activeKeys.isEmpty) return 'Neutral';
    return 'Active: ${activeKeys.join(" + ")}';
  }

  /// OSC 送信モニター
  Widget _buildOscMonitor(GamepadProvider provider) {
    final oscX = provider.activeOscX;
    final oscY = provider.activeOscY;
    final isJumping = provider.isJumping;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target: ${provider.config.oscHost}:${provider.config.oscPort} (UDP)',
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 8),
        _buildValueBar('/input/Horizontal', oscX, const Color(0xFF10B981)),
        const SizedBox(height: 6),
        _buildValueBar('/input/Vertical', oscY, const Color(0xFF10B981)),
        const SizedBox(height: 6),
        Row(
          children: [
            const SizedBox(
              width: 140,
              child: Text('/input/Jump', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isJumping ? const Color(0xFFEC4899) : Colors.white10,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isJumping ? '1 (JUMP)' : '0 (OFF)',
                style: TextStyle(
                  color: isJumping ? Colors.white : Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 仮想ゲームパッド モニター
  Widget _buildGamepadMonitor(GamepadProvider provider) {
    final gpX = provider.activeGamepadX;
    final gpY = provider.activeGamepadY;
    final isJumping = provider.isJumping;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Virtual XInput Controller Output',
          style: TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 8),
        _buildValueBar('L-Stick X', gpX, const Color(0xFF38BDF8)),
        const SizedBox(height: 6),
        _buildValueBar('L-Stick Y', gpY, const Color(0xFF38BDF8)),
        const SizedBox(height: 6),
        Row(
          children: [
            const SizedBox(
              width: 140,
              child: Text('A Button (Jump)', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isJumping ? const Color(0xFFEC4899) : Colors.white10,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isJumping ? 'PRESSED' : 'RELEASED',
                style: TextStyle(
                  color: isJumping ? Colors.white : Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildValueBar(String label, double value, Color activeColor) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: (value + 1.0) / 2.0, // -1.0..+1.0 -> 0.0..1.0
            backgroundColor: const Color(0xFF0F172A),
            color: activeColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 42,
          child: Text(
            value.toStringAsFixed(2),
            textAlign: TextAlign.end,
            style: TextStyle(color: activeColor, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
