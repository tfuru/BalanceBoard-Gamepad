import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamepad_provider.dart';
import '../models/app_config.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late TextEditingController _hostController;
  late TextEditingController _portController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GamepadProvider>(context, listen: false);
    _hostController = TextEditingController(text: provider.config.oscHost);
    _portController = TextEditingController(text: provider.config.oscPort.toString());
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

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
          // 出力モード設定 Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '出力モード選択',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '※ OSC as Input Controller モードを ON にすると、仮想ゲームパッド出力は OFF になります。',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  RadioListTile<OutputMode>(
                    title: const Text('仮想ゲームパッド (Virtual Gamepad)', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('PC ゲーム用のゲームパッドとして入力中継', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    value: OutputMode.virtualGamepad,
                    groupValue: provider.config.outputMode,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (val) {
                      if (val != null) provider.setOutputMode(val);
                    },
                  ),
                  RadioListTile<OutputMode>(
                    title: const Text('OSC as Input Controller (VRChat用)', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('VRChat (/input/Horizontal, /input/Vertical) へ UDP 送信', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    value: OutputMode.oscInputController,
                    groupValue: provider.config.outputMode,
                    activeColor: const Color(0xFF10B981),
                    onChanged: (val) {
                      if (val != null) provider.setOutputMode(val);
                    },
                  ),
                  RadioListTile<OutputMode>(
                    title: const Text('WASD キーボード (WASD Keyboard)', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('重心移動を W, A, S, D キーの押下に直接変換', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    value: OutputMode.keyboardWasd,
                    groupValue: provider.config.outputMode,
                    activeColor: const Color(0xFFF59E0B),
                    onChanged: (val) {
                      if (val != null) provider.setOutputMode(val);
                    },
                  ),
                  RadioListTile<OutputMode>(
                    title: const Text('出力 OFF', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('モニター画面のみ（入力中継なし）', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    value: OutputMode.none,
                    groupValue: provider.config.outputMode,
                    activeColor: Colors.grey,
                    onChanged: (val) {
                      if (val != null) provider.setOutputMode(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // WASD 詳細設定 Card
          if (provider.config.outputMode == OutputMode.keyboardWasd) ...[
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WASD キーボード設定',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF332A15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFF59E0B)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.accessibility_new, color: Color(0xFFF59E0B), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'macOS で他のアプリに WASD キーを送るには「システム設定 > プライバシーとセキュリティ > アクセシビリティ」で権限を許可する必要があります。',
                              style: TextStyle(color: Color(0xFFFDE68A), fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'キー入力反応しきい値 (Threshold)',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          provider.config.wasdThreshold.toStringAsFixed(2),
                          style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Slider(
                      value: provider.config.wasdThreshold,
                      min: 0.05,
                      max: 0.40,
                      divisions: 35,
                      activeColor: const Color(0xFFF59E0B),
                      onChanged: (val) => provider.setWasdThreshold(val),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('A/D (左右) 反転', style: TextStyle(color: Colors.white)),
                      value: provider.config.invertWasdX,
                      activeColor: const Color(0xFFF59E0B),
                      onChanged: (val) => provider.setInvertWasdX(val),
                    ),
                    SwitchListTile(
                      title: const Text('W/S (前後) 反転', style: TextStyle(color: Colors.white)),
                      value: provider.config.invertWasdY,
                      activeColor: const Color(0xFFF59E0B),
                      onChanged: (val) => provider.setInvertWasdY(val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],


          // OSC 詳細設定 Card
          if (provider.config.outputMode == OutputMode.oscInputController) ...[
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'OSC 送信設定 (VRChat)',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _hostController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: '送信先 IP アドレス',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              if (val.trim().isNotEmpty) {
                                provider.setOscHost(val.trim());
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _portController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'ポート',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              final port = int.tryParse(val.trim());
                              if (port != null && port > 0) {
                                provider.setOscPort(port);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('左右軸 (Horizontal) 反転', style: TextStyle(color: Colors.white)),
                      value: provider.config.invertOscX,
                      activeColor: const Color(0xFF10B981),
                      onChanged: (val) => provider.setInvertOscX(val),
                    ),
                    SwitchListTile(
                      title: const Text('前後軸 (Vertical) 反転', style: TextStyle(color: Colors.white)),
                      value: provider.config.invertOscY,
                      activeColor: const Color(0xFF10B981),
                      onChanged: (val) => provider.setInvertOscY(val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

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

