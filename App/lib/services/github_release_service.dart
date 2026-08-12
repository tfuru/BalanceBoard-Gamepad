import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/github_release.dart';

class GithubReleaseService {
  final http.Client _client;

  GithubReleaseService({http.Client? client}) : _client = client ?? http.Client();

  /// GitHub から Release / Tag 一覧を取得 (/releases と /tags を結合)
  Future<List<GithubRelease>> fetchReleases({String repository = 'tfuru/BalanceBoard-Gamepad'}) async {
    final releasesUrl = Uri.parse('https://api.github.com/repos/$repository/releases');
    final tagsUrl = Uri.parse('https://api.github.com/repos/$repository/tags');

    final headers = {
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'BalanceBoard-Gamepad-App',
    };

    final Map<String, GithubRelease> releaseMap = {};

    // 1. /releases の取得
    try {
      final response = await _client.get(releasesUrl, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        for (final item in jsonList) {
          final release = GithubRelease.fromJson(item as Map<String, dynamic>);
          if (release.tagName.isNotEmpty) {
            releaseMap[release.tagName] = release;
          }
        }
      }
    } catch (_) {}

    // 2. /tags の取得 (/releases にまだ登場していない Tag もカバー)
    try {
      final response = await _client.get(tagsUrl, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        for (final item in jsonList) {
          final tagName = item['name'] as String? ?? '';
          if (tagName.isNotEmpty && !releaseMap.containsKey(tagName)) {
            releaseMap[tagName] = GithubRelease(
              tagName: tagName,
              name: tagName,
              body: 'ビルド中またはバイナリ未添付のタグ',
              publishedAt: '',
              assets: [],
            );
          }
        }
      }
    } catch (_) {}

    if (releaseMap.isEmpty) {
      throw Exception('タグ・リリースの取得に失敗しました (リポジトリ: $repository)');
    }

    return releaseMap.values.toList();
  }


  /// 指定したアセット (.bin) をダウンロードしてローカルファイルとして一時保存
  Future<File> downloadFirmwareAsset(
    GithubReleaseAsset asset, {
    void Function(double progress)? onProgress,
  }) async {
    final req = http.Request('GET', Uri.parse(asset.browserDownloadUrl));
    req.headers['User-Agent'] = 'BalanceBoard-Gamepad-App';

    final res = await _client.send(req);
    if (res.statusCode != 200) {
      throw Exception('ファームウェアのダウンロードに失敗しました (Status: ${res.statusCode})');
    }

    final totalBytes = res.contentLength ?? asset.size;
    int downloadedBytes = 0;

    final tempDir = await getTemporaryDirectory();
    final saveFile = File(p.join(tempDir.path, asset.name));
    final sink = saveFile.openWrite();

    await for (final chunk in res.stream) {
      downloadedBytes += chunk.length;
      sink.add(chunk);

      if (totalBytes > 0 && onProgress != null) {
        onProgress(downloadedBytes / totalBytes);
      }
    }

    await sink.flush();
    await sink.close();

    return saveFile;
  }
}
