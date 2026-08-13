import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/gamepad_provider.dart';
import '../models/app_config.dart';
import 'components/firmware_update_card.dart';
import 'components/app_version_card.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<GamepadProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 言語切替 Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 10),
                      Text(
                        l10n.languageSetting,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  DropdownButton<Locale>(
                    dropdownColor: const Color(0xFF1E293B),
                    value: provider.locale,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: Locale('ja'),
                        child: Text('日本語 (Japanese)', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (locale) {
                      if (locale != null) {
                        provider.setLocale(locale);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const AppVersionCard(),
          const SizedBox(height: 12),
          const FirmwareUpdateCard(),
          const SizedBox(height: 16),
          // 出力モード設定 Card

          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.outputModeSetting,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  RadioListTile<OutputMode>(
                    title: Text(OutputMode.virtualGamepad.getLocalizedLabel(l10n), style: const TextStyle(color: Colors.white)),
                    subtitle: Text(l10n.modeVirtualGamepadDesc, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    value: OutputMode.virtualGamepad,
                    groupValue: provider.config.outputMode,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (val) {
                      if (val != null) provider.setOutputMode(val);
                    },
                  ),
                  RadioListTile<OutputMode>(
                    title: Text(OutputMode.oscInputController.getLocalizedLabel(l10n), style: const TextStyle(color: Colors.white)),
                    subtitle: Text(l10n.modeOscDesc, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    value: OutputMode.oscInputController,
                    groupValue: provider.config.outputMode,
                    activeColor: const Color(0xFF10B981),
                    onChanged: (val) {
                      if (val != null) provider.setOutputMode(val);
                    },
                  ),
                  RadioListTile<OutputMode>(
                    title: Text(OutputMode.keyboardWasd.getLocalizedLabel(l10n), style: const TextStyle(color: Colors.white)),
                    subtitle: Text(l10n.modeWasdDesc, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    value: OutputMode.keyboardWasd,
                    groupValue: provider.config.outputMode,
                    activeColor: const Color(0xFFF59E0B),
                    onChanged: (val) {
                      if (val != null) provider.setOutputMode(val);
                    },
                  ),
                  RadioListTile<OutputMode>(
                    title: Text(OutputMode.none.getLocalizedLabel(l10n), style: const TextStyle(color: Colors.white)),
                    subtitle: Text(l10n.modeNoneDesc, style: const TextStyle(color: Colors.white54, fontSize: 11)),
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
                    Text(
                      l10n.wasdDetailSetting,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.wasdThreshold,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
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
                      title: Text(l10n.invertWasdX, style: const TextStyle(color: Colors.white)),
                      value: provider.config.invertWasdX,
                      activeThumbColor: const Color(0xFFF59E0B),
                      onChanged: (val) => provider.setInvertWasdX(val),
                    ),
                    SwitchListTile(
                      title: Text(l10n.invertWasdY, style: const TextStyle(color: Colors.white)),
                      value: provider.config.invertWasdY,
                      activeThumbColor: const Color(0xFFF59E0B),
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
                    Text(
                      l10n.oscDetailSetting,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _hostController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: l10n.oscHost,
                              labelStyle: const TextStyle(color: Colors.white70),
                              border: const OutlineInputBorder(),
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
                            decoration: InputDecoration(
                              labelText: l10n.oscPort,
                              labelStyle: const TextStyle(color: Colors.white70),
                              border: const OutlineInputBorder(),
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
                      title: Text(l10n.invertOscX, style: const TextStyle(color: Colors.white)),
                      value: provider.config.invertOscX,
                      activeThumbColor: const Color(0xFF10B981),
                      onChanged: (val) => provider.setInvertOscX(val),
                    ),
                    SwitchListTile(
                      title: Text(l10n.invertOscY, style: const TextStyle(color: Colors.white)),
                      value: provider.config.invertOscY,
                      activeThumbColor: const Color(0xFF10B981),
                      onChanged: (val) => provider.setInvertOscY(val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ジャンプ検出設定 Card
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
                      Row(
                        children: [
                          const Icon(Icons.unfold_more, color: Color(0xFFEC4899), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l10n.jumpSetting,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Switch(
                        value: provider.config.enableJump,
                        activeThumbColor: const Color(0xFFEC4899),
                        onChanged: (val) => provider.setEnableJump(val),
                      ),
                    ],
                  ),
                  if (provider.config.enableJump) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.jumpThreshold,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        Text(
                          '${provider.config.jumpThresholdKg.toStringAsFixed(1)} kg',
                          style: const TextStyle(color: Color(0xFFEC4899), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Slider(
                      value: provider.config.jumpThresholdKg,
                      min: 1.0,
                      max: 15.0,
                      divisions: 28,
                      activeColor: const Color(0xFFEC4899),
                      onChanged: (val) => provider.setJumpThresholdKg(val),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

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
                      Text(
                        l10n.deadzone,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                      Text(
                        l10n.sensitivity,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
              title: const Text('Baud Rate', style: TextStyle(color: Colors.white)),
              subtitle: Text('${provider.config.baudRate} bps', style: const TextStyle(color: Colors.white54)),
              trailing: const Icon(Icons.speed, color: Color(0xFF38BDF8)),
            ),
          ),
        ],
      ),
    );
  }
}

