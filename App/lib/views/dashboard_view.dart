import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/app_config.dart';
import '../providers/gamepad_provider.dart';
import 'components/cog_painter.dart';
import 'components/output_status_card.dart';
import 'help_view.dart';
import 'settings_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<GamepadProvider>(context);
    final data = provider.currentData;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/app_icon.png',
                width: 28,
                height: 28,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.appTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            tooltip: l10n.helpTooltip,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            tooltip: l10n.settingsTooltip,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                        hint: Text(l10n.selectPortHint, style: const TextStyle(color: Colors.white54)),
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
                        tooltip: l10n.refreshPortsTooltip,
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
                        label: Text(provider.isSerialConnected ? l10n.disconnectBtn : l10n.connectBtn),
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
                      Expanded(
                        child: Text(
                          'Status: ${provider.getStatusMessage(l10n)}',
                          style: TextStyle(
                            color: provider.isSerialConnected ? const Color(0xFF10B981) : Colors.white60,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<OutputMode>(
                            dropdownColor: const Color(0xFF1E293B),
                            value: provider.config.outputMode,
                            underline: const SizedBox(),
                            isDense: true,
                            items: OutputMode.values.map((mode) {
                              return DropdownMenuItem<OutputMode>(
                                value: mode,
                                child: Text(
                                  mode.getLocalizedLabel(l10n),
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
            Container(
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
                    data.isConnected
                        ? '● Balance Board ${l10n.connected}'
                        : '○ Balance Board ${l10n.disconnected}',
                    style: TextStyle(
                      color: data.isConnected ? const Color(0xFF10B981) : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricChip(l10n.totalWeight, '${data.weightKg.toStringAsFixed(1)} kg'),
                      _buildMetricChip('X Axis', data.centerX.toStringAsFixed(2)),
                      _buildMetricChip('Y Axis', data.centerY.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // リアルタイム出力確認モニター欄
            const OutputStatusCard(),
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
                label: Text(
                  l10n.tareBtn,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
