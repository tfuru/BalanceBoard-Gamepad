import 'dart:async';
import 'package:flutter/foundation.dart';

/// Wii Balance Board の荷重推移を監視し、ジャンプ動作を検知するクラス
class JumpDetector {
  bool _isJumping = false;
  bool _wasOnBoard = false;
  DateTime _lastJumpTime = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _holdTimer;

  /// 現在ジャンプ出力中かどうか
  bool get isJumping => _isJumping;

  /// 毎フレームの合計重量 (weightKg) からジャンプの発生を判定
  /// ジャンプが新たに検出された場合に true を返す
  bool processWeight(
    double weightKg, {
    required double thresholdKg,
    required bool enabled,
    required int holdMs,
    int cooldownMs = 400,
  }) {
    if (!enabled) {
      _isJumping = false;
      return false;
    }

    final now = DateTime.now();

    // ボードに乗っている（十分な体重が掛かっている）かの判定 (閾値の2倍以上)
    bool currentlyOnBoard = weightKg > (thresholdKg * 2.0).clamp(8.0, 30.0);

    bool newlyTriggered = false;

    // 「乗っていた状態」から「足が離れた（重量が閾値以下）」かつ「クールダウン経過後」
    if (_wasOnBoard && weightKg <= thresholdKg) {
      if (now.difference(_lastJumpTime).inMilliseconds >= cooldownMs) {
        _isJumping = true;
        _lastJumpTime = now;
        newlyTriggered = true;
        debugPrint('[JumpDetector] 🦘 JUMP DETECTED! (Weight: ${weightKg.toStringAsFixed(1)} kg <= Threshold: ${thresholdKg} kg)');

        // 一定時間 (holdMs) 後に自動リリース
        _holdTimer?.cancel();
        _holdTimer = Timer(Duration(milliseconds: holdMs), () {
          _isJumping = false;
        });
      }
    }

    _wasOnBoard = currentlyOnBoard;
    return newlyTriggered;
  }

  void reset() {
    _isJumping = false;
    _wasOnBoard = false;
    _holdTimer?.cancel();
  }

  void dispose() {
    reset();
  }
}
