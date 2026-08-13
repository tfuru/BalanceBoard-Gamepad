import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          l10n.helpTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ヘッダー案内
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF38BDF8), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.helpSection1Body,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // セクションタイトル
          Text(
            l10n.helpSection2Title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildStepCard(
            stepNumber: 1,
            icon: Icons.usb,
            title: l10n.helpSection2Step1,
            description: '',
          ),
          _buildStepCard(
            stepNumber: 2,
            icon: Icons.settings_input_hdmi,
            title: l10n.helpSection2Step2,
            description: '',
          ),
          _buildStepCard(
            stepNumber: 3,
            icon: Icons.sports_esports,
            title: l10n.helpSection2Step3,
            description: '',
          ),

          const SizedBox(height: 24),

          // 出力モード
          Text(
            l10n.helpSection3Title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                  Text(
                    l10n.helpSection3Osc,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.helpSection3Wasd,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // トラブルシューティング
          Text(
            l10n.helpSection4Title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Troubleshooting',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.helpSection4Item1,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.helpSection4Item2,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required int stepNumber,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ステップ番号バッジ
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF38BDF8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$stepNumber',
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // 詳細コンテンツ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: const Color(0xFF38BDF8), size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
