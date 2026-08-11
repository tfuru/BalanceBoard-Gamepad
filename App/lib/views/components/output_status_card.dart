import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_config.dart';
import '../../providers/gamepad_provider.dart';

/// 選択中出力モードの動作・キー押下・送信パラメータをリアルタイム監視・確認できるモニターカード
class OutputStatusCard extends StatelessWidget {
  const OutputStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                'リアルタイム出力モニター (${mode.label})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildModeContent(context, provider, mode),
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

  Widget _buildModeContent(BuildContext context, GamepadProvider provider, OutputMode mode) {
    switch (mode) {
      case OutputMode.keyboardWasd:
        return _buildWasdMonitor(provider);
      case OutputMode.oscInputController:
        return _buildOscMonitor(provider);
      case OutputMode.virtualGamepad:
        return _buildGamepadMonitor(provider);
      case OutputMode.none:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              '出力中継は停止しています（デバッグ表示のみ）',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        );
    }
  }

  /// WASD キーボード押下モニター
  Widget _buildWasdMonitor(GamepadProvider provider) {
    final kb = provider.keyboardService;
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
        const SizedBox(height: 8),
        Text(
          _getActiveKeyText(kb),
          style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
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

  String _getActiveKeyText(dynamic kb) {
    final activeKeys = <String>[];
    if (kb.isWPressed) activeKeys.add('W (前進)');
    if (kb.isAPressed) activeKeys.add('A (左傾)');
    if (kb.isSPressed) activeKeys.add('S (後退)');
    if (kb.isDPressed) activeKeys.add('D (右傾)');

    if (activeKeys.isEmpty) return 'キー押下なし (ニュートラル)';
    return '押下中: ${activeKeys.join(" + ")}';
  }

  /// OSC 送信モニター
  Widget _buildOscMonitor(GamepadProvider provider) {
    final oscX = provider.activeOscX;
    final oscY = provider.activeOscY;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '送信先: ${provider.config.oscHost}:${provider.config.oscPort} (UDP)',
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 8),
        _buildValueBar('/input/Horizontal (左右)', oscX, const Color(0xFF10B981)),
        const SizedBox(height: 6),
        _buildValueBar('/input/Vertical (前後)', oscY, const Color(0xFF10B981)),
      ],
    );
  }

  /// 仮想ゲームパッド モニター
  Widget _buildGamepadMonitor(GamepadProvider provider) {
    final gpX = provider.activeGamepadX;
    final gpY = provider.activeGamepadY;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '仮想 XInput コントローラー出力中',
          style: TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 8),
        _buildValueBar('L-Stick X 軸', gpX, const Color(0xFF38BDF8)),
        const SizedBox(height: 6),
        _buildValueBar('L-Stick Y 軸', gpY, const Color(0xFF38BDF8)),
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
