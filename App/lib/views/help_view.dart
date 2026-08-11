import 'package:flutter/material.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          '接続手順 & ヘルプ',
          style: TextStyle(fontWeight: FontWeight.bold),
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
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF38BDF8), size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Wii Balance Board と ESP32 を接続し、常駐アプリへデータを取り込むための手順案内です。',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // セクションタイトル
          const Text(
            '接続ステップ Guide',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildStepCard(
            stepNumber: 1,
            icon: Icons.usb,
            title: 'ESP-WROOM-32 を PC と接続',
            description: 'ESP-WROOM-32 (Adafruit HUZZAH32) を USB ケーブルで PC に接続します。',
          ),
          _buildStepCard(
            stepNumber: 2,
            icon: Icons.settings_input_hdmi,
            title: 'COM ポート / シリアル名を確認',
            description: 'アプリのドロップダウンメニューに接続中のシリアルポート名（例: /dev/cu.usbserial-... や COM3）が表示されているか確認します。',
          ),
          _buildStepCard(
            stepNumber: 3,
            icon: Icons.sports_esports,
            title: 'Wii Balance Board の SYNC ボタンを押す',
            description: 'Balance Board の電池ケース蓋を外し、裏面の赤い SYNC ボタンを押します。表の青色 LED が点滅しペアリング受付状態になります。',
          ),
          _buildStepCard(
            stepNumber: 4,
            icon: Icons.link,
            title: '常駐アプリでシリアル指定・接続',
            description: 'アプリ画面で認識されたシリアルポートを選択し、「接続」ボタンを押します。ESP32 が自動的に Balance Board を検出・接続します。',
          ),
          _buildStepCard(
            stepNumber: 5,
            icon: Icons.scale,
            title: '0点 (Tare) リセットの実行',
            description: 'Wii Balance Board に何も乗っていない状態で、画面下の「Tare (零点リセット)」ボタンを押し、合計重量を 0.0kg に初期化します。',
          ),
          _buildStepCard(
            stepNumber: 6,
            icon: Icons.directions_run,
            title: '乗下荷・動作確認',
            description: 'Wii Balance Board に乗り、体重移動を行って画面の 4 隅圧力インジケーターおよび 2D 重心ドットが追従することを確認します。',
          ),

          const SizedBox(height: 24),

          // トラブルシューティング
          const Text(
            'トラブルシューティング Tips',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        '接続できない / データが変わらない場合',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '・ターミナル等で make monitor が起動中だと、シリアルポートが排他ロックされアプリで受信できません。make monitor を停止してください。\n'
                    '・ペアリングが成功しない場合は、Balance Board の電池を抜いて数秒待ってから再セットし、SYNC ボタンを押してください。',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
