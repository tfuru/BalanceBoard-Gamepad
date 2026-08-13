import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/gamepad_provider.dart';
import '../../models/github_release.dart';

class FirmwareUpdateCard extends StatefulWidget {
  const FirmwareUpdateCard({super.key});

  @override
  State<FirmwareUpdateCard> createState() => _FirmwareUpdateCardState();
}

class _FirmwareUpdateCardState extends State<FirmwareUpdateCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GamepadProvider>(context, listen: false);
      if (provider.releases.isEmpty && !provider.isFetchingReleases) {
        provider.fetchGithubReleases();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<GamepadProvider>(context);

    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.system_update_alt, color: Color(0xFF38BDF8)),
                const SizedBox(width: 8),
                Text(
                  l10n.fwUpdateTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: provider.isFetchingReleases
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.refresh, color: Colors.white70),
                  tooltip: l10n.refreshReleases,
                  onPressed: provider.isFlashingFirmware
                      ? null
                      : () => provider.fetchGithubReleases(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tag 選択ドロップダウン
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(l10n.fwTagSelect, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<GithubRelease>(
                        value: provider.releases.contains(provider.selectedRelease)
                            ? provider.selectedRelease
                            : (provider.releases.isNotEmpty ? provider.releases.first : null),
                        dropdownColor: const Color(0xFF0F172A),
                        isExpanded: true,
                        hint: Text(l10n.tagSelectHint, style: const TextStyle(color: Colors.white38)),
                        items: provider.releases.map((release) {
                          final hasBin = release.firmwareAsset != null;
                          return DropdownMenuItem<GithubRelease>(
                            value: release,
                            child: Row(
                              children: [
                                Text(
                                  release.tagName,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    release.name.isNotEmpty ? '(${release.name})' : '',
                                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (hasBin)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.greenAccent, width: 0.5),
                                    ),
                                    child: const Text('BIN', style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: provider.isFlashingFirmware
                            ? null
                            : (val) => provider.setSelectedRelease(val),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 書き込み対象シリアルポート
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(l10n.targetPortSelect, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: provider.config.selectedPort.isNotEmpty &&
                                provider.availablePorts.contains(provider.config.selectedPort)
                            ? provider.config.selectedPort
                            : (provider.availablePorts.isNotEmpty ? provider.availablePorts.first : null),
                        dropdownColor: const Color(0xFF0F172A),
                        isExpanded: true,
                        hint: Text(l10n.selectPortHint, style: const TextStyle(color: Colors.white38)),
                        items: provider.availablePorts.map((port) {
                          return DropdownMenuItem<String>(
                            value: port,
                            child: Text(port, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: provider.isFlashingFirmware
                            ? null
                            : (val) {
                                if (val != null) provider.setSelectedPort(val);
                              },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // プログレスバー & ログ表示
            if (provider.isFlashingFirmware || provider.flashProgress > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: provider.flashProgress,
                  backgroundColor: const Color(0xFF0F172A),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
            ],

            if (provider.flashLog.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  provider.flashLog,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                ),
              ),

            if (provider.flashError != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.redAccent, width: 0.5),
                ),
                child: Text(
                  provider.flashError!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // アクションボタン
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: provider.isFlashingFirmware
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.flash_on),
                label: Text(
                  provider.isFlashingFirmware
                      ? '${l10n.flashingInProgress} (${(provider.flashProgress * 100).toStringAsFixed(0)}%)'
                      : l10n.startFlashBtn,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onPressed: provider.isFlashingFirmware || provider.selectedRelease == null
                    ? null
                    : () {
                        _showConfirmFlashDialog(context, provider, l10n);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmFlashDialog(BuildContext context, GamepadProvider provider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(l10n.fwUpdateTitle, style: const TextStyle(color: Colors.white)),
        content: Text(
          'Tag [${provider.selectedRelease?.tagName}] -> Port [${provider.config.selectedPort}]',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
            child: Text(l10n.startFlashBtn, style: const TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.flashSelectedFirmware();
            },
          ),
        ],
      ),
    );
  }
}
