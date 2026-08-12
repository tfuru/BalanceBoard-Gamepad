class GithubReleaseAsset {
  final String name;
  final int size;
  final String browserDownloadUrl;

  GithubReleaseAsset({
    required this.name,
    required this.size,
    required this.browserDownloadUrl,
  });

  factory GithubReleaseAsset.fromJson(Map<String, dynamic> json) {
    return GithubReleaseAsset(
      name: json['name'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      browserDownloadUrl: json['browser_download_url'] as String? ?? '',
    );
  }
}

class GithubRelease {
  final String tagName;
  final String name;
  final String body;
  final String publishedAt;
  final List<GithubReleaseAsset> assets;

  GithubRelease({
    required this.tagName,
    required this.name,
    required this.body,
    required this.publishedAt,
    required this.assets,
  });

  factory GithubRelease.fromJson(Map<String, dynamic> json) {
    final rawAssets = json['assets'] as List<dynamic>? ?? [];
    final parsedAssets = rawAssets
        .map((a) => GithubReleaseAsset.fromJson(a as Map<String, dynamic>))
        .toList();

    return GithubRelease(
      tagName: json['tag_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      body: json['body'] as String? ?? '',
      publishedAt: json['published_at'] as String? ?? '',
      assets: parsedAssets,
    );
  }

  /// ファームウェアバイナリ (.bin) アセットの検索
  GithubReleaseAsset? get firmwareAsset {
    // 優先順位: 1. balance_board_firmware-featheresp32.bin 2. *.bin
    try {
      return assets.firstWhere(
        (a) => a.name == 'balance_board_firmware-featheresp32.bin',
      );
    } catch (_) {
      try {
        return assets.firstWhere((a) => a.name.endsWith('.bin'));
      } catch (_) {
        return null;
      }
    }
  }
}
