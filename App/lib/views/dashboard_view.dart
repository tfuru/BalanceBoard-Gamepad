import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_config.dart';
import '../providers/gamepad_provider.dart';
import 'components/cog_painter.dart';
import 'help_view.dart';
import 'settings_view.dart';


class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GamepadProvider>(context);
    final data = provider.currentData;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.sports_esports, color: Color(0xFF38BDF8)),
            SizedBox(width: 10),
            Text(
              'BalanceBoard Gamepad Relay',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            tooltip: '接続手順・ヘルプ',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            tooltip: '設定',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 上部 コネクション・ステータスバー
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      DropdownButton<String>(
                        dropdownColor: const Color(0xFF1E293B),
                        value: provider.config.selectedPort.isNotEmpty &&
                                provider.availablePorts.contains(provider.config.selectedPort)
                            ? provider.config.selectedPort
                            : null,
                        hint: const Text('COMポート選択', style: TextStyle(color: Colors.white54)),
                        items: provider.availablePorts.map((port) {
                          return DropdownMenuItem<String>(
                            value: port,
                            child: Text(port, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: provider.isSerialConnected
                            ? null
                            : (val) {
                                if (val != null) provider.setSelectedPort(val);
                              },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white70),
                        onPressed: provider.isSerialConnected ? null : provider.refreshPorts,
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: provider.isSerialConnected
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: Icon(provider.isSerialConnected ? Icons.link_off : Icons.link),
                        label: Text(provider.isSerialConnected ? '切断' : '接続'),
                        onPressed: () {
                          if (provider.isSerialConnected) {
                            provider.disconnect();
                          } else {
                            provider.connect();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ステータス: ${provider.statusMessage}',
                        style: TextStyle(
                          color: provider.isSerialConnected ? const Color(0xFF10B981) : Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          const Text('出力モード: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          DropdownButton<OutputMode>(
                            dropdownColor: const Color(0xFF1E293B),
                            value: provider.config.outputMode,
                            underline: const SizedBox(),
                            isDense: true,
                            items: OutputMode.values.map((mode) {
                              return DropdownMenuItem<OutputMode>(
                                value: mode,
                                child: Text(
                                  mode.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: mode == OutputMode.oscInputController
                                        ? const Color(0xFF10B981)
                                        : (mode == OutputMode.keyboardWasd
                                            ? const Color(0xFFF59E0B)
                                            : (mode == OutputMode.virtualGamepad
                                                ? const Color(0xFF38BDF8)
                                                : Colors.white54)),

                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (mode) {
                              if (mode != null) provider.setOutputMode(mode);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // メイン 2D 重心レーダー描画領域
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Text(
                      data.isConnected ? '● Balance Board 接続中' : '○ Balance Board 未接続',
                      style: TextStyle(
                        color: data.isConnected ? const Color(0xFF10B981) : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: CustomPaint(
                          painter: CoGPainter(
                            centerX: data.centerX,
                            centerY: data.centerY,
                            rawTR: data.topRight,
                            rawBR: data.bottomRight,
                            rawTL: data.topLeft,
                            rawBL: data.bottomLeft,
                            deadzone: provider.config.deadzone,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricChip('合計重量', '${data.weightKg.toStringAsFixed(1)} kg'),
                        _buildMetricChip('X 軸', data.centerX.toStringAsFixed(2)),
                        _buildMetricChip('Y 軸', data.centerY.toStringAsFixed(2)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 下部 コントロールボタン (Tare リセット)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.scale),
                label: const Text(
                  'Tare (零点リセット)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: provider.isSerialConnected ? provider.sendTareCommand : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF38BDF8),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
