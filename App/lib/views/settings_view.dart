import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamepad_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GamepadProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('詳細設定 & キャリブレーション'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // デッドゾーン設定 Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'デッドゾーン (遊び)',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        provider.config.deadzone.toStringAsFixed(2),
                        style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: provider.config.deadzone,
                    min: 0.00,
                    max: 0.20,
                    divisions: 20,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (val) {
                      provider.setDeadzone(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 感度設定 Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '感度倍率 (Sensitivity)',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${provider.config.sensitivity.toStringAsFixed(1)}x',
                        style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: provider.config.sensitivity,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (val) {
                      provider.setSensitivity(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 通信設定 Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: const Text('ボーレート', style: TextStyle(color: Colors.white)),
              subtitle: Text('${provider.config.baudRate} bps', style: const TextStyle(color: Colors.white54)),
              trailing: const Icon(Icons.speed, color: Color(0xFF38BDF8)),
            ),
          ),
        ],
      ),
    );
  }
}
