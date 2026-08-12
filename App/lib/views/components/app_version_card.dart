import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/gamepad_provider.dart';

class AppVersionCard extends StatelessWidget {
  const AppVersionCard({super.key});

  Future<void> _openGitHubReleases() async {
    final url = Uri.parse('https://github.com/tfuru/BalanceBoard-Gamepad/releases');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GamepadProvider>(context);
    final latest = provider.latestAppRelease;
    final isChecking = provider.isCheckingUpdate;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: provider.hasAppUpdate ? const Color(0xFF10B981) : Colors.white10,
          width: provider.hasAppUpdate ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.system_update_alt,
                color: provider.hasAppUpdate ? const Color(0xFF10B981) : const Color(0xFF38BDF8),
              ),
              const SizedBox(width: 8),
              const Text(
                'アプリ＆ファームウェア バージョン確認',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF334155),
                  foregroundColor: Colors.white,
                ),
                icon: isChecking
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.sync, size: 16),
                label: Text(isChecking ? '確認中...' : 'バージョン確認'),
                onPressed: isChecking ? null : () => provider.checkAppUpdate(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildVersionBadge('現在のアプリ', 'v${GamepadProvider.currentAppVersion}', Colors.white70),
              const SizedBox(width: 16),
              if (latest != null)
                _buildVersionBadge(
                  'GitHub 最新Tag',
                  latest.tagName,
                  provider.hasAppUpdate ? const Color(0xFF10B981) : Colors.white70,
                ),
            ],
          ),
          if (provider.updateCheckMessage != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: provider.hasAppUpdate
                    ? const Color(0xFF065F46)
                    : const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      provider.updateCheckMessage!,
                      style: TextStyle(
                        color: provider.hasAppUpdate ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight: provider.hasAppUpdate ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 14, color: Color(0xFF38BDF8)),
                    label: const Text('GitHub で確認', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12)),
                    onPressed: _openGitHubReleases,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVersionBadge(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
